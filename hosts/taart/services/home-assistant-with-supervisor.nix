{
  imports = [
    ./podman.nix
    ./mosquitto.nix
    ./zigbee2mqtt.nix
  ];
  virtualisation.oci-containers = {
    backend = "podman";
    containers.hassio-supervisor = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "Europe/Amsterdam";
      image = "ghcr.io/home-assistant/aarch64-hassio-supervisor:2022.12.1";
    };
    containers.homeassistant = {
      volumes = [ "home-assistant:/config" ];
      environment.TZ = "Europe/Amsterdam";
      image = "ghcr.io/home-assistant/rasperrypi4-64-home-assistant:2023.1.5";
      extraOptions = [
        "--network=host"
        "--device=/dev/ttyACM0:/dev/ttyACM0"
      ];
    };
  };
  systemd.services.podman-hassio-supervisor = { };
  systemd.services.hassio-apparmor = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "podman-hassio-supervisor.service" ];
    before = [ "podman-hassio-supervisor.service" ];
    description = "Hass.io AppArmor";
    serviceConfig = { };
  };
}
