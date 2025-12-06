{
  config,
  inputs,
  ...
}:
let
  port = 5050;
in
{
  sops.secrets = {
    "appdaemon-environmentFile" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      mode = "0440";
    };
  };
  virtualisation.oci-containers.containers.appdaemon = {
    image = "registry.hub.docker.com/acockburn/appdaemon:latest";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    autoStart = true;

    ports = [
      "${toString port}:5050"
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
