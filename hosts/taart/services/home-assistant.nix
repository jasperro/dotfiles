{
  imports = [
    ../../common/optional/podman.nix
    ./mosquitto.nix
    ./zigbee2mqtt.nix
  ];
  virtualisation.oci-containers = {
    backend = "podman";
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
}
