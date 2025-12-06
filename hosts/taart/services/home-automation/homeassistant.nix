{ config, ... }:
let
  cfg = {
    configDir = "/var/lib/hass/homeassistant";
  };
  port = 8123;
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
    image = "ghcr.io/home-assistant/home-assistant:latest";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    autoStart = true;
    volumes = [
      "${cfg.configDir}:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment.TZ = "Europe/Amsterdam";
    extraOptions = [
      "--network=host"
      "--cap-add=CAP_NET_RAW,CAP_NET_BIND_SERVICE"
    ];
    ports = [
      "${toString port}:8123"
    ];
  };

  systemd.services."podman-homeassistant" = {
    # after = [ "mysql.service" ];
    # requires = [ "mysql.service" ];
    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];
  };

  services.nginx.virtualHosts."home.albering.nl" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
      '';
    };
  };
}
