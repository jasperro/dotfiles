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

        network = lib.mkOption {
          default = { };
          type = lib.types.submodule {
            options = {
              baseDomain = lib.mkOption {
                type = lib.types.str;
                default = "albering.nl";
                description = "Base domain used for DNS resolution";
              };

              lanDevices = lib.mkOption {
                type = lib.types.attrsOf (lib.types.listOf lib.types.str);
                default = {
                  "192.168.1.16" = [
                    "taart"
                    "vault"
                    "home"
                    "z2m"
                  ];
                  "192.168.1.31" = [
                    "camera"
                  ];
                };
                description = "Map of IP addresses to lists of subdomains";
              };
            };
          };
        };

        wireguard = lib.mkOption {
          default = { };
          type = lib.types.submodule {
            options = {
              enable = lib.mkEnableOption "wireguard service";
              port = lib.mkOption {
                type = lib.types.port;
                default = 51820;
              };
              host = lib.mkOption {
                type = lib.types.str;
                default = "vpn.albering.nl";
              };
              externalInterface = lib.mkOption {
                type = lib.types.str;
                default = "end0";
              };
            };
          };
        };

        vaultwarden = lib.mkOption {
          default = { };
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
          default = { };
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
            lib.optionals (cfg.wireguard.enable) [
              jdf.hosts._.taart._.services._.wireguard
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
