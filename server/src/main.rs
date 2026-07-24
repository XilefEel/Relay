use axum::{
    Json, Router,
    extract::{
        State,
        ws::{Message, WebSocket, WebSocketUpgrade},
    },
    response::IntoResponse,
    routing::get,
};
use serde::Serialize;
use std::{sync::Arc, time::Duration};
use sysinfo::System;
use tokio::sync::Mutex;

#[derive(Serialize)]
struct SystemInfo {
    cpu_usage: f32,
    ram_usage_mb: u64,
    total_ram_mb: u64,
}

type SharedSystem = Arc<Mutex<System>>;

async fn snapshot(sys: &SharedSystem) -> SystemInfo {
    let mut sys = sys.lock().await;

    sys.refresh_cpu_usage();
    tokio::time::sleep(Duration::from_millis(200)).await;
    sys.refresh_cpu_usage();

    sys.refresh_memory();

    SystemInfo {
        cpu_usage: sys.global_cpu_usage(),
        ram_usage_mb: sys.used_memory() / 1024 / 1024,
        total_ram_mb: sys.total_memory() / 1024 / 1024,
    }
}

async fn get_stats(State(sys): State<SharedSystem>) -> Json<SystemInfo> {
    Json(snapshot(&sys).await)
}

async fn ws_handler(ws: WebSocketUpgrade, State(sys): State<SharedSystem>) -> impl IntoResponse {
    ws.on_upgrade(move |socket| handle_socket(socket, sys))
}

async fn handle_socket(mut socket: WebSocket, sys: SharedSystem) {
    loop {
        let stats = snapshot(&sys).await;

        let json = match serde_json::to_string(&stats) {
            Ok(j) => j,
            Err(_) => break,
        };

        if socket.send(Message::Text(json.into())).await.is_err() {
            break;
        }

        tokio::time::sleep(Duration::from_secs(1)).await;
    }
}

#[tokio::main]
async fn main() {
    let system = Arc::new(Mutex::new(System::new_all()));

    let app = Router::new()
        .route("/api/stats", get(get_stats))
        .route("/ws/stats", get(ws_handler))
        .with_state(system);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();

    println!("Server running on http://0.0.0.0:3000");

    axum::serve(listener, app).await.unwrap();
}
