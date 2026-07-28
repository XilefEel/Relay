use axum::{
    Json,
    extract::{Path, State},
    http::StatusCode,
};
use serde::{Deserialize, Serialize};
use std::{collections::HashMap, fs, process::Command};

use crate::state::AppState;

#[derive(Deserialize, Serialize, Clone)]
pub struct ActionConfig {
    id: String,
    label: String,
    icon: String,
    command: String,
}

pub fn load_actions() -> HashMap<String, ActionConfig> {
    let data = fs::read_to_string("actions.json").unwrap_or_else(|_| "[]".to_string());
    let actions: Vec<ActionConfig> = serde_json::from_str(&data).unwrap_or_default();
    actions.into_iter().map(|a| (a.id.clone(), a)).collect()
}

async fn save_actions(map: &HashMap<String, ActionConfig>) -> std::io::Result<()> {
    let list: Vec<&ActionConfig> = map.values().collect();
    let json = serde_json::to_string_pretty(&list)?;
    fs::write("actions.json", json)
}

pub async fn get_actions(State(state): State<AppState>) -> Json<Vec<ActionConfig>> {
    let actions = state.actions.lock().await;
    Json(actions.values().cloned().collect())
}

pub async fn run_action(State(state): State<AppState>, Path(id): Path<String>) -> StatusCode {
    let actions = state.actions.lock().await;
    match actions.get(&id) {
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

pub async fn create_action(
    State(state): State<AppState>,
    Json(new_action): Json<ActionConfig>,
) -> StatusCode {
    let mut actions = state.actions.lock().await;
    if actions.contains_key(&new_action.id) {
        return StatusCode::CONFLICT;
    }

    actions.insert(new_action.id.clone(), new_action);
    match save_actions(&actions).await {
        Ok(_) => StatusCode::CREATED,
        Err(e) => {
            eprintln!("Failed to save actions: {}", e);
            StatusCode::INTERNAL_SERVER_ERROR
        }
    }
}

pub async fn update_action(
    State(state): State<AppState>,
    Path(id): Path<String>,
    Json(updated): Json<ActionConfig>,
) -> StatusCode {
    let mut actions = state.actions.lock().await;
    if !actions.contains_key(&id) {
        return StatusCode::NOT_FOUND;
    }
    actions.insert(id, updated);
    match save_actions(&actions).await {
        Ok(_) => StatusCode::OK,
        Err(_) => StatusCode::INTERNAL_SERVER_ERROR,
    }
}

pub async fn delete_action(State(state): State<AppState>, Path(id): Path<String>) -> StatusCode {
    let mut actions = state.actions.lock().await;
    if actions.remove(&id).is_none() {
        return StatusCode::NOT_FOUND;
    }

    match save_actions(&actions).await {
        Ok(_) => StatusCode::OK,
        Err(_) => StatusCode::INTERNAL_SERVER_ERROR,
    }
}
