use axum::{
    extract::{
        State,
        ws::{Message, WebSocket, WebSocketUpgrade},
    },
    response::IntoResponse,
};
use serde::Serialize;
use std::time::Duration;
use sysinfo::{Disks, Networks};

use crate::state::AppState;

#[derive(Serialize)]
pub struct SystemInfo {
    cpu_usage: f32,
    ram_usage_mb: u64,
    total_ram_mb: u64,
    disk_usage_gb: u64,
    disk_total_gb: u64,
    network_download_kbps: u64,
    network_upload_kbps: u64,
}

const BYTES_PER_KB: u64 = 1024;
const BYTES_PER_MB: u64 = BYTES_PER_KB * 1024;
const REFRESH_INTERVAL: Duration = Duration::from_secs(1);
const ELAPSED_TIME: f32 = 0.2;

async fn get_stats(state: &AppState) -> SystemInfo {
    let mut sys = state.system.lock().await;

    sys.refresh_cpu_usage();
    tokio::time::sleep(Duration::from_millis(200)).await;
    sys.refresh_cpu_usage();
    sys.refresh_memory();

    let disks = Disks::new_with_refreshed_list();
    let (disk_used, disk_total) = disks.iter().fold((0u64, 0u64), |(used, total), disk| {
        let disk_total_bytes = disk.total_space();
        let disk_avail_bytes = disk.available_space();
        (
            used + (disk_total_bytes - disk_avail_bytes),
            total + disk_total_bytes,
        )
    });

    let networks = Networks::new_with_refreshed_list();
    let (total_received, total_transmitted) = networks
        .iter()
        .fold((0u64, 0u64), |(rx, tx), (_name, data)| {
            (rx + data.total_received(), tx + data.total_transmitted())
        });

    let mut network_history = state.network_history.lock().await;

    let download_kbps = ((total_received - network_history.last_received) as f32
        / BYTES_PER_KB as f32)
        / ELAPSED_TIME;
    let upload_kbps = ((total_transmitted - network_history.last_transmitted) as f32
        / BYTES_PER_KB as f32)
        / ELAPSED_TIME;

    network_history.last_received = total_received;
    network_history.last_transmitted = total_transmitted;

    drop(network_history);

    SystemInfo {
        cpu_usage: sys.global_cpu_usage(),
        ram_usage_mb: sys.used_memory() / BYTES_PER_MB,
        total_ram_mb: sys.total_memory() / BYTES_PER_MB,
        disk_usage_gb: disk_used / (BYTES_PER_MB * 1024),
        disk_total_gb: disk_total / (BYTES_PER_MB * 1024),
        network_download_kbps: download_kbps as u64,
        network_upload_kbps: upload_kbps as u64,
    }
}

pub async fn health() -> &'static str {
    "ok"
}

async fn handle_socket(mut socket: WebSocket, state: AppState) {
    loop {
        let stats = get_stats(&state).await;

        let Ok(json) = serde_json::to_string(&stats) else {
            break;
        };

        if socket.send(Message::Text(json.into())).await.is_err() {
            break;
        }

        tokio::time::sleep(REFRESH_INTERVAL).await;
    }
}

pub async fn ws_handler(ws: WebSocketUpgrade, State(sys): State<AppState>) -> impl IntoResponse {
    ws.on_upgrade(move |socket| handle_socket(socket, sys))
}
