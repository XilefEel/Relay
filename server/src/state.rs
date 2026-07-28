use crate::actions::ActionConfig;
use std::{collections::HashMap, sync::Arc};
use sysinfo::System;
use tokio::sync::Mutex;

pub type SharedSystem = Arc<Mutex<System>>;

pub type ActionMap = Arc<Mutex<HashMap<String, ActionConfig>>>;

pub struct NetworkHistory {
    pub last_received: u64,
    pub last_transmitted: u64,
}

#[derive(Clone)]
pub struct AppState {
    pub system: SharedSystem,
    pub actions: ActionMap,
    pub network_history: Arc<Mutex<NetworkHistory>>,
}
