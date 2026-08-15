{
  jdf,
  lib,
  ...
}:
{
  jdf.hosts._.taart._.service-configs = {
    settings = {
      services = {
        enable = lib.mkEnableOption "service configurations";

        headscale = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "headscale service";
              port = lib.mkOption {
                type = lib.types.port;
                default = 8080;
              };
              dataDir = lib.mkOption {
                type = lib.types.str;
                default = "/etc/headscale";
              };
              host = lib.mkOption {
                type = lib.types.str;
                default = "vpn.albering.nl";
              };
              url = lib.mkOption {
                type = lib.types.str;
                default = "https://vpn.albering.nl";
              };
            };
          };
        };

        vaultwarden = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "vaultwarden service";
              port = lib.mkOption {
                type = lib.types.port;
                default = 8222;
              };
              dataDir = lib.mkOption {
                type = lib.types.str;
                default = "/var/lib/vaultwarden";
              };
            };
          };
        };

        homeassistant = lib.mkOption {
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "homeassistant service";
              port = lib.mkOption {
                type = lib.types.port;
                default = 8123;
              };
              configDir = lib.mkOption {
                type = lib.types.str;
                default = "/var/lib/hass/homeassistant";
              };
            };
          };
        };
      };
    };

    includes = [
      (
        { host, ... }:
        let
          cfg = host.settings.services;
        in
        {
          includes =
            lib.optionals (cfg.headscale.enable) [
              jdf.hosts._.taart._.services._.headscale
            ]
            ++ lib.optionals (cfg.vaultwarden.enable) [
              jdf.hosts._.taart._.services._.vaultwarden
            ]
            ++ lib.optionals (cfg.homeassistant.enable) [
              jdf.hosts._.taart._.services._.home-automation._.homeassistant
            ];
        }
      )
    ];
  };
}
