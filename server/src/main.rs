mod actions;
mod state;
mod stats;
mod discovery;

use axum::{
    Router, response::Html, routing::{get, post},
};
use std::sync::Arc;
use sysinfo::System;
use tokio::sync::Mutex;

use crate::{
    actions::{create_action, delete_action, get_actions, load_actions, run_action, update_action}, discovery::discovery_listener, state::AppState, stats::{health, ws_handler},
};

async fn admin_page() -> Html<&'static str> {
    Html(include_str!("../static/admin.html"))
}

#[tokio::main]
async fn main() {
    let state = AppState {
        system: Arc::new(Mutex::new(System::new_all())),
        actions: Arc::new(Mutex::new(load_actions())),
        network_history: Arc::new(Mutex::new(state::NetworkHistory {
            last_received: 0,
            last_transmitted: 0,
        })),
    };

    tokio::spawn(discovery_listener());

    let app = Router::new()
        .route("/api/health", get(health))
        .route("/ws/stats", get(ws_handler))
        .route("/api/actions", get(get_actions).post(create_action))
        .route(
            "/api/actions/{id}",
            post(run_action).put(update_action).delete(delete_action),
        )
        .route("/admin", get(admin_page))
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("Server running on http://0.0.0.0:3000");
    println!("Admin page available at http://localhost:3000/admin");

    axum::serve(listener, app).await.unwrap();
}
