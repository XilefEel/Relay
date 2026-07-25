mod state;
mod stats;

use axum::{Router, routing::get};
use std::sync::Arc;
use sysinfo::System;
use tokio::sync::Mutex;

use crate::stats::{health, ws_handler};

#[tokio::main]
async fn main() {
    let system = Arc::new(Mutex::new(System::new_all()));

    let app = Router::new()
        .route("/api/health", get(health))
        .route("/ws/stats", get(ws_handler))
        .with_state(system);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("Server running on http://0.0.0.0:3000");

    axum::serve(listener, app).await.unwrap();
}
