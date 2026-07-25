use axum::{
    Json,
    extract::{Path, State},
    http::StatusCode,
};
use serde::{Deserialize, Serialize};
use std::{fs, process::Command, sync::Arc};

use crate::state::{ActionMap, AppState};

#[derive(Deserialize, Serialize, Clone)]
pub struct ActionConfig {
    id: String,
    label: String,
    icon: String,
    command: String,
}

pub fn load_actions() -> ActionMap {
    let data = fs::read_to_string("actions.json").expect("failed to read actions.json");
    let actions: Vec<ActionConfig> = serde_json::from_str(&data).expect("invalid actions.json");
    let map = actions.into_iter().map(|a| (a.id.clone(), a)).collect();
    Arc::new(map)
}

pub async fn get_actions(State(state): State<AppState>) -> Json<Vec<ActionConfig>> {
    Json(state.actions.values().cloned().collect())
}

pub async fn run_action(State(state): State<AppState>, Path(id): Path<String>) -> StatusCode {
    match state.actions.get(&id) {
        Some(action) => match Command::new(&action.command).spawn() {
            Ok(_) => StatusCode::OK,
            Err(e) => {
                eprintln!("Failed to run action '{}': {}", id, e);
                StatusCode::INTERNAL_SERVER_ERROR
            }
        },
        None => StatusCode::NOT_FOUND,
    }
}
