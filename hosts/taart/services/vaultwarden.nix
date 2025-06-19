{ config, ... }:
{
  imports = [ ./nginx.nix ];
  # SOPS secret for admin token
  sops.secrets.vaultwarden-environmentFile = {
    sopsFile = ../secrets.yaml;
    key = "vaultwarden-environmentFile";
    owner = "vaultwarden";
    group = "vaultwarden";
    mode = "0440";
  };

  # Enable Vaultwarden using the NixOS module
  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    environmentFile = config.sops.secrets.vaultwarden-environmentFile.path;

    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = false;
      WEB_VAULT_ENABLED = true;
      WEBSOCKET_ENABLED = true;
      DOMAIN = "https://home.albering.nl/bitwarden/";
    };
  };

  services.nginx.virtualHosts."home.albering.nl" = {
    locations."/bitwarden/" = {
      proxyPass = "http://127.0.0.1:8222";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_http_version 1.1;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };

    locations."~* /bitwarden/admin$" = {
      proxyPass = "http://127.0.0.1:8222";
      extraConfig = ''
        deny all;
        allow 192.168.1.0/24;
        proxy_set_header Host $host;
        proxy_redirect http:// https://;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
