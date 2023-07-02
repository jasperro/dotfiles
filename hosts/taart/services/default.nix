{
  imports = [
    ../../common/optional/openssh-inbound.nix
    ./podman.nix
    ./postgresql.nix
    ./mosquitto.nix
    ./zigbee2mqtt.nix
    ./nginx.nix
    ./home-assistant.nix
  ];
}
