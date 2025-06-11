{
  virtualisation.oci-containers.containers.appdaemon = {
    image = "acockburn/appdaemon:latest";
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
      # HA_URL = "";
      # HA_TOKEN = "";
    };
  };
}
