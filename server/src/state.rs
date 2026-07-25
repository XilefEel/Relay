use std::sync::Arc;
use sysinfo::System;
use tokio::sync::Mutex;

pub type SharedSystem = Arc<Mutex<System>>;
