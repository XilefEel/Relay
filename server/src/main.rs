use axum::{extract::State, routing::get, Json, Router};
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

async fn get_stats(State(sys): State<SharedSystem>) -> Json<SystemInfo> {
    let mut sys = sys.lock().await;

    sys.refresh_cpu_usage();
    tokio::time::sleep(Duration::from_millis(200)).await;
    sys.refresh_cpu_usage();

    sys.refresh_memory();

    Json(SystemInfo {
        cpu_usage: sys.global_cpu_usage(),
        ram_usage_mb: sys.used_memory() / 1024 / 1024,
        total_ram_mb: sys.total_memory() / 1024 / 1024,
    })
}

#[tokio::main]
async fn main() {
    let system = Arc::new(Mutex::new(System::new_all()));

    let app = Router::new()
        .route("/api/stats", get(get_stats))
        .with_state(system);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000")
        .await
        .unwrap();

    println!("Server running on http://0.0.0.0:3000");

    axum::serve(listener, app).await.unwrap();
}