{
  inputs,
  lib,
  den,
  ...
}:
let
  port = 5432;
in
{
  JDF.hosts._.taart._.services._.database._.postgresql = den.lib.parametric {
    includes = [
      (
        {
          host,
          ...
        }:
        {
          nixos =
            { pkgs, config, ... }:
            {
              key = "postgresql";
              sops.secrets =
                lib.optionalAttrs (host ? enabled.homeassistant) {
                  "postgresql/roles/hass/password" = {
                    sopsFile = "${inputs.secrets}/taart.yaml";
                    owner = "postgres";
                    group = "hass";
                    mode = "0440";
                  };
                }
                // lib.optionalAttrs (host ? enabled.grafana) {
                  "postgresql/roles/grafanareader/password" = {
                    sopsFile = "${inputs.secrets}/taart.yaml";
                    owner = "postgres";
                    group = "grafana";
                    mode = "0440";
                  };
                };
              sops.templates."init-db.sql" = {
                owner = "postgres";
                group = "postgres";
                mode = "0440";
                content = ''
                  ${lib.optionalString (host ? enabled.homeassistant) ''
                    CREATE ROLE hass WITH LOGIN PASSWORD '${
                      config.sops.placeholder."postgresql/roles/hass/password"
                    }' CREATEDB;
                  ''}
                  ${lib.optionalString (host ? enabled.grafana) ''
                    CREATE ROLE grafanareader WITH LOGIN PASSWORD '${
                      config.sops.placeholder."postgresql/roles/grafanareader/password"
                    }';
                  ''}
                  GRANT ALL PRIVILEGES ON DATABASE homeassistant TO hass;
                  GRANT ALL PRIVILEGES ON DATABASE ltss TO hass;
                  \c homeassistant;
                  GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafanareader;
                  \c ltss;
                  GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafanareader;
                '';
              };
              # Port 5432
              services.postgresql = {
                enable = true;
                package = pkgs.postgresql_17;
                # dataDir = "/var/lib/postgresql";
                extensions =
                  ps: with ps; [
                    postgis
                    timescaledb
                  ];
                settings.shared_preload_libraries = [ "timescaledb" ];
                ensureDatabases = [
                  "homeassistant"
                  "ltss"
                ];
                authentication = pkgs.lib.mkOverride 10 ''
                  #type   database        DBuser    origin-address       auth-method
                  local   all             all                            trust

                  # ipv4
                  host    all             all       127.0.0.1/32         trust
                  # ipv6
                  host    all             all       ::1/128              trust
                '';
                initialScript = config.sops.templates."init-db.sql".path;
              };
            };
        }
      )
    ];
  };
}
