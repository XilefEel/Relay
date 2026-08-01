use tokio::net::UdpSocket;
use serde::Serialize;

const DISCOVERY_PORT: u16 = 4000;
const DISCOVERY_MESSAGE: &[u8] = b"RELAY_DISCOVER";

#[derive(Serialize)]
pub struct DiscoveryResponse {
    pub name: String,
    pub ip: String,
    pub port: u16,
}

pub async fn discovery_listener() {
    let socket = UdpSocket::bind(("0.0.0.0", DISCOVERY_PORT))
        .await
        .expect("failed to bind discovery UDP socket");

    println!("Discovery listener running on UDP port {}", DISCOVERY_PORT);

    let mut buffer = [0u8; 1024];

    loop {
        match socket.recv_from(&mut buffer).await {
            Ok((len, addr)) => {
                if &buffer[..len] == DISCOVERY_MESSAGE {
                    let response = DiscoveryResponse {
                        name: hostname().unwrap_or_else(|| "Relay PC".to_string()),
                        ip: addr.ip().to_string(),
                        port: 3000,
                    };

                    if let Ok(json) = serde_json::to_vec(&response) {
                        let _ = socket.send_to(&json, addr).await;
                    }
                }
            }
            Err(e) => {
                eprintln!("Error receiving discovery message: {}", e);
            }
        }
    }
}

fn hostname() -> Option<String> {
    std::env::var("COMPUTERNAME").ok()
}