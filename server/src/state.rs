use crate::actions::ActionConfig;
use std::{collections::HashMap, sync::Arc};
use sysinfo::System;
use tokio::sync::Mutex;

pub type SharedSystem = Arc<Mutex<System>>;

pub type ActionMap = Arc<HashMap<String, ActionConfig>>;

#[derive(Clone)]
pub struct AppState {
    pub system: SharedSystem,
    pub actions: ActionMap,
}
