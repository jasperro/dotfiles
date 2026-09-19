# Taart (Server Configuration)

Taart is a Raspberry Pi 4 configured as a central home server. This document outlines the services currently running on it, services available to be enabled, and potential ideas for future additions.

## Currently Used Services

These services are currently active and included in the main `taart.nix` configuration:

### Core / Infrastructure
- **OpenSSH** (via `../../modules/services/openssh-inbound.nix`): Secure shell access.
- **ACME** (`services/acme.nix`): Let's Encrypt SSL certificate generation and automatic renewal.
- **Nginx** (`services/nginx.nix`): Reverse proxy for exposing web interfaces securely.
- **Podman** (`services/podman.nix`): Container engine for running containerized applications.

### Database
- **PostgreSQL** (`services/database/postgresql`): Relational database, used as a backend for other services.
- **Grafana + Prometheus / InfluxDB** (currently not used): Detailed metric gathering and visualization for both server system health and long-term home automation data.

### Home Automation (`services/home-automation/`)
- **Home Assistant**: The core smart home hub.
- **Mosquitto**: MQTT broker for IoT messaging.
- **Zigbee2MQTT**: Bridge to control Zigbee devices via MQTT.
- **ESPHome**: Management system for custom ESP8266/ESP32/OpenBeken microcontroller IoT devices.
- **AppDaemon**: Framework for writing Python-based automation apps for Home Assistant.
- **Matterbridge**: Bridge to connect various unsupported protocols into Home Assistant.
- **Grott**: Growatt solar inverter data interception and forwarding.

### Applications
- **Vaultwarden** (`services/vaultwarden.nix`): Lightweight, unofficial Bitwarden-compatible password manager backend.

## Ideas for Future Services
- **Pi-hole / AdGuard Home**: Network-wide ad blocking and local DNS resolution.
- **WireGuard / Tailscale headless client**: Secure VPN for accessing your `taart` services and home network remotely.
- **Uptime / Status / Security dashboard**: Self-hosted dashboard to monitor the uptime of your network and internet-facing services.
- **Nextcloud**: Self-hosted file synchronization and backup, removing reliance on proprietary cloud storage (though external storage attached to the Pi is recommended).
- **Gitea / Forgejo**: A lightweight Git server to host local repositories securely.
- **Paperless-ngx**: A document management system for archiving and searching digitized physical documents.
- **Jellyfin**: Media server (audio/video).
