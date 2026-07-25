mod actions;
mod state;
mod stats;

use axum::{
    Router,
    routing::{get, post},
};
use std::sync::Arc;
use sysinfo::System;
use tokio::sync::Mutex;

use crate::{
    actions::{get_actions, load_actions, run_action},
    state::AppState,
    stats::{health, ws_handler},
};

#[tokio::main]
async fn main() {
    let state = AppState {
        system: Arc::new(Mutex::new(System::new_all())),
        actions: load_actions(),
    };

    let app = Router::new()
        .route("/api/health", get(health))
        .route("/ws/stats", get(ws_handler))
        .route("/api/actions", get(get_actions))
        .route("/api/actions/{id}", post(run_action))
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("Server running on http://0.0.0.0:3000");

    axum::serve(listener, app).await.unwrap();
}
