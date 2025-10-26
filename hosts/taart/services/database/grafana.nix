{
  config,
  lib,
  inputs,
  ...
}:
let
  port = 3000;
in
{
  sops.secrets."grafana/admin-password" = {
    sopsFile = "${inputs.secrets}/taart.yaml";
    owner = "grafana";
    group = "grafana";
    mode = "0440";
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        protocol = "http";
        min_tls_version = "";
        http_port = port;
        http_addr = "127.0.0.1";
        enforce_domain = false;
        # enable_gzip = true;
        domain = "home.albering.nl";
        root_url = "%(protocol)s://%(domain)s:%(http_port)s/api/ingress/grafana/";
      };
      "auth.proxy" = {
        enabled = true;
        header_name = "X-WEBAUTH-USER";
        header_property = "username";
        auto_sign_up = true;
      };
      security = {
        allow_embedding = true;
        admin_user = "admin";
        admin_password = "$__file{${config.sops.secrets."grafana/admin-password".path}}";
      };
      analytics.reporting_enabled = false;
    };
    dataDir = "/var/lib/grafana";
    provision = {
      datasources = {
        settings.datasources =
          lib.optionals config.services.loki.enable [
            {
              name = "Loki";
              type = "loki";
              access = "proxy";
              url = "http://localhost:${toString config.services.loki.configuration.server.http_listen_port}";
            }
          ]
          ++ lib.optionals config.services.prometheus.enable [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://localhost:${toString config.services.prometheus.port}";
            }
          ]
          ++ lib.optionals config.services.postgresql.enable [
            {
              name = "PostgreSQL";
              type = "postgres";
              access = "proxy";
              url = "127.0.0.1:${toString config.services.postgresql.settings.port}";
              user = "grafanareader";
              secureJsonData = {
                password = "$__file{${config.sops.secrets."postgresql/roles/grafanareader/password".path}}";
              };
              jsonData = {
                database = "ltss";
                sslmode = "disable";
                maxOpenConns = 100;
                maxIdleConns = 100;
                maxIdleConnsAuto = true;
                connMaxLifetime = 14400;
                timescaledb = true;
              };
            }
          ];
      };
      # dashboards = {
      #   settings = [
      #     {
      #       name = "Simple Logs Dashboard";
      #       orgId = 1;
      #       folder = "";
      #       editable = true;
      #       dashboard = {
      #         title = "Simple Logs";
      #         panels = [
      #           {
      #             type = "logs";
      #             title = "Loki Logs";
      #             datasource = "Loki";
      #             targets = [
      #               {
      #                 expr = "{job=\"grafana\"}";
      #               }
      #             ];
      #             gridPos = {
      #               h = 8;
      #               w = 24;
      #               x = 0;
      #               y = 0;
      #             };
      #           }
      #         ];
      #       };
      #     }
      #   ];
      # };
    };
  };

  # networking.firewall.allowedTCPPorts = [
  #   port
  # ];
}
