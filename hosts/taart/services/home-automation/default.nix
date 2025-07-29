{
  imports = [
    ../podman.nix
    ../nginx.nix
    ../mariadb.nix
    ./mosquitto.nix
    ./zigbee2mqtt
    ./homeassistant.nix
    ./esphome.nix
    ./appdaemon.nix
    # ./ledfx.nix
    ./grott
  ];
}
