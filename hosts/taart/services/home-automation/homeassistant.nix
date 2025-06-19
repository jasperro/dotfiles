{ oci-images, config, ... }:
let
  cfg = {
    configDir = "/var/lib/hass/homeassistant";
  };
in
{
  users.users.hass = {
    home = cfg.configDir;
    createHome = true;
    group = "hass";
    uid = config.ids.uids.hass;
    homeMode = "770";
  };

  users.groups.hass.gid = config.ids.gids.hass;

  virtualisation.oci-containers.containers.homeassistant = {
    inherit (oci-images.home-assistant) image imageFile;
    autoStart = true;
    volumes = [
      "${cfg.configDir}:/config"
      "/etc/localtime:/etc/localtime:ro"
      "/run/mysqld/mysqld.sock:/run/mysqld/mysqld.sock"
    ];
    environment.TZ = "Europe/Amsterdam";
    extraOptions = [
      "--network=host"
      # "--device=/dev/ttyACM0:/dev/ttyACM0"
      # DO NOT USE THIS OUTSIDE LXC
      # "--privileged"
    ];
    # ports = [
    #   # Temp overlap due to LXC
    #   "8124:8123"
    # ];
  };

  systemd.services."podman-homeassistant" = {
    after = [ "mysql.service" ];
    requires = [ "mysql.service" ];
  };

  services.nginx.virtualHosts."home.albering.nl" = {
    locations."/".extraConfig = ''
      proxy_pass http://127.0.0.1:8123;
      proxy_set_header Host $host;
      proxy_redirect http:// https://;
      proxy_http_version 1.1;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    '';
  };
}
