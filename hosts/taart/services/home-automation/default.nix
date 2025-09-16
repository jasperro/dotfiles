{
  imports = [
    ../podman.nix
    ../nginx.nix
    ../database/mariadb.nix
    ../database/postgresql.nix
    ../database/prometheus.nix
    # ../database/loki.nix
    ../database/grafana.nix
    ./mosquitto.nix
    ./zigbee2mqtt
    ./homeassistant.nix
    ./esphome.nix
    ./appdaemon.nix
    # ./ledfx.nix
    ./grott
  ];
}
