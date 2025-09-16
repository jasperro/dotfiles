{
  pkgs,
  config,
  inputs,
  ...
}:
let
  port = 5432;
in
{
  sops.secrets = {
    "postgresql/roles/hass/password" = {
      sopsFile = "${inputs.secrets}/taart.yaml";
      owner = "postgres";
      group = "hass";
      mode = "0440";
    };
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
      CREATE ROLE hass WITH LOGIN PASSWORD '${
        config.sops.placeholder."postgresql/roles/hass/password"
      }' CREATEDB;
      CREATE ROLE grafanareader WITH LOGIN PASSWORD '${
        config.sops.placeholder."postgresql/roles/grafanareader/password"
      }';
      GRANT ALL PRIVILEGES ON DATABASE homeassistant TO hass;
      \c homeassistant;
      GRANT ALL PRIVILEGES ON SCHEMA public TO hass;
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
    ensureDatabases = [ "homeassistant" ];
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
}
