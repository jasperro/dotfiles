{ self, jdf, ... }:
{
  jdf.hosts._.taart._.services._.vaultwarden = {
    includes = [ jdf.hosts._.taart._.services._.nginx ];
    nixos =
      { config, host, ... }:
      let
        cfg = host.settings.services.vaultwarden;
      in
      {
        sops.secrets.vaultwarden-environmentFile = {
          sopsFile = "${self}/secrets/taart.yaml";
          key = "vaultwarden-environmentFile";
          owner = "vaultwarden";
          group = "vaultwarden";
          mode = "0440";
        };

        services.vaultwarden = {
          enable = true;
          dbBackend = "sqlite";
          environmentFile = config.sops.secrets.vaultwarden-environmentFile.path;

          config = {
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = cfg.port;
            SIGNUPS_ALLOWED = false;
            WEB_VAULT_ENABLED = true;
            WEBSOCKET_ENABLED = true;
            DOMAIN = "https://vault.albering.nl/";
          };
        };

        services.nginx.virtualHosts."vault.albering.nl" = {
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
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          locations."/admin" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            extraConfig = ''
              error_page 403 = @drop;
              allow 10.42.1.0/24;
              deny all;

              proxy_set_header Host $host;
              proxy_redirect http:// https://;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };
  };
}
