{ jdf, ... }:
{
  jdf.hosts._.taart._.services._.home-automation._.homeassistant = {
    nixos =
      { config, host, ... }:
      let
        cfg = host.settings.services.homeassistant;
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
            "${toString cfg.port}:8123"
          ];
        };

        systemd.services."podman-homeassistant" = {
          after = [ "postgresql.service" ];
          requires = [ "postgresql.service" ];
        };

        services.nginx.virtualHosts."home.albering.nl" = {
          useACMEHost = "albering";
          forceSSL = true;

          locations."@drop".extraConfig = "return 444;";

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            extraConfig = ''
              error_page 403 = @drop;
              allow 10.42.1.0/24;
              allow 10.42.0.0/24;
              deny all;

              proxy_set_header Host $host;
              proxy_redirect http:// https://;
              proxy_http_version 1.1;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection $connection_upgrade;
            '';
          };
        };
      };
  };
}
