use axum::{
    extract::{
        State,
        ws::{Message, WebSocket, WebSocketUpgrade},
    },
    response::IntoResponse,
};
use serde::Serialize;
use std::time::Duration;

use crate::state::AppState;

#[derive(Serialize)]
pub struct SystemInfo {
    cpu_usage: f32,
    ram_usage_mb: u64,
    total_ram_mb: u64,
}

const BYTES_PER_MB: u64 = 1024 * 1024;
const REFRESH_INTERVAL: Duration = Duration::from_secs(1);

async fn get_stats(state: &AppState) -> SystemInfo {
    let mut sys = state.system.lock().await;

    sys.refresh_cpu_usage();
    tokio::time::sleep(Duration::from_millis(200)).await;
    sys.refresh_cpu_usage();
    sys.refresh_memory();

    SystemInfo {
        cpu_usage: sys.global_cpu_usage(),
        ram_usage_mb: sys.used_memory() / BYTES_PER_MB,
        total_ram_mb: sys.total_memory() / BYTES_PER_MB,
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

pub async fn ws_handler(
    ws: WebSocketUpgrade,
    State(sys): State<AppState>,
) -> impl IntoResponse {
    ws.on_upgrade(move |socket| handle_socket(socket, sys))
}
