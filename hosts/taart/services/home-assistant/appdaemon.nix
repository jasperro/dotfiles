{ config, oci-images, ... }:
{
  networking.firewall.allowedTCPPorts = [ 5050 ];
  sops.secrets = {
    "appdaemon-environmentFile" = {
      sopsFile = ../../secrets.yaml;
    };
  };
  virtualisation.oci-containers.containers.appdaemon = {
    inherit (oci-images.appdaemon) image imageFile;
    autoStart = true;

    ports = [
      "5050:5050" # Exposes AppDaemon dashboard on host:5050
    ];

    volumes = [
      "/var/lib/hass/homeassistant/appdaemon:/conf"
    ];

    extraOptions = [
      "--network=host"
    ];

    environment = {
      TZ = "Europe/Amsterdam";
      HA_URL = "https://127.0.0.1";
      # TOKEN = "";
    };

    environmentFiles = [
      config.sops.secrets.appdaemon-environmentFile.path
    ];
  };
}
