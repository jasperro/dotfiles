{ inputs, config, ... }:
{
  sops.secrets = {
    "matter-hub-environmentFile" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      mode = "0440";
    };
  };
  virtualisation.oci-containers.containers.matter-hub = {
    image = "ghcr.io/t0bst4r/home-assistant-matter-hub:latest";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    autoStart = true;
    environment = {
      HAMH_HOME_ASSISTANT_URL = "http://127.0.0.1:8123/";
      HAMH_LOG_LEVEL = "info";
      HAMH_HTTP_PORT = "8482";
    };
    volumes = [
      "/var/lib/home-assistant-matter-hub:/data"
    ];
    extraOptions = [
      "--network=host"
    ];
    environmentFiles = [
      config.sops.secrets.matter-hub-environmentFile.path
    ];
    dependsOn = [ "homeassistant" ];
  };

  networking.firewall.allowedTCPPorts = [
    5540
  ];
  networking.firewall.allowedUDPPorts = [
    5540
  ];

  # virtualisation.oci-containers.containers.homeassistant.dependsOn = [ "matter-server" ];

  virtualisation.oci-containers.containers.matter-server = {
    image = "ghcr.io/matter-js/python-matter-server:stable";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    autoStart = true;
    extraOptions = [
      "--network=host"
      "--security-opt=apparmor:unconfined"
    ];
    volumes = [
      "/var/lib/matter-server:/data"
      "/run/dbus:/run/dbus:ro"
    ];
  };
}
