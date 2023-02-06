{ pkgs, ... }: {
  imports = [
    ../../../common/optional/arion.nix
  ];
  virtualisation.arion.projects.home-assistant.settings = {
    services = {
      nginx = {
        nixos.useSystemd = true;
        nixos.configuration = import ./nginx.nix;
      };

      home-assistant = {
        service = {
          image = "ghcr.io/home-assistant/rasperrypi4-64-home-assistant:latest";
          # image = "ghcr.io/home-assistant/home-assistant:latest";
          container_name = "homeassistant";
          hostname = "homeassistant";
          restart = "unless-stopped";
          network_mode = "host";
          environment = {
            "TZ" = "Europe/Amsterdam";
          };
          devices = [ "/dev/ttyACM0:/dev/ttyACM0" ];
          volumes = [ "/var/lib/hass/homeassistant:/config:rw" ];
          tmpfs = [
          ];
          labels = { };
          useHostStore = true;
        };
      };

      zigbee2mqtt = {
        nixos.useSystemd = true;
        nixos.configuration = import ./zigbee2mqtt.nix;
        service = {
          volumes = [ "/var/lib/hass/zigbee2mqtt:/config:rw" ];
        };
      };

      mosquitto = {
        nixos.useSystemd = true;
        nixos.configuration = {
          services.mosquitto = {
            enable = true;
            listeners = [{
              users = {
                mosquitto = {
                  hashedPassword = "$6$IelzC+f0VnizZt46$9vt3K23ezggMxxDX9uXwexZ7W65+7faCuwNGYpJpxDm4GKwE3OCeD6l/tB+etDqVxd9UcWJPCgWp3EEkq6d2nQ==";
                };
              };
            }];
          };
        };
        service = {
          volumes = [ "/var/lib/hass/mosquitto:/config:rw" ];
        };
      };

      postgres = {
        service = {
          volumes = [ "/var/lib/hass/postgres:/var/lib/postgresql:rw" ];
        };
        nixos.useSystemd = true;
        nixos.configuration = {
          services.postgresql = {
            enable = true;
            dataDir = "/var/lib/postgresql";
            ensureDatabases = [ "hass" ];
            ensureUsers = [
              {
                name = "hass";
                ensurePermissions = {
                  "DATABASE hass" = "ALL PRIVILEGES";
                };
              }
            ];
          };
        };
      };
    };
  };
}
