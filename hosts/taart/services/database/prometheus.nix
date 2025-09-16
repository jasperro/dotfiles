{ config, lib, ... }:
{
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "localhost:${toString config.services.prometheus.exporters.node.port}"
              "localhost:${toString config.services.prometheus.exporters.postgres.port}"
            ];
          }
        ];
      }
    ];
    exporters = {
      # systemd = {
      #   enable = true;
      # };

      node = {
        enable = true;
        port = 9100;
        enabledCollectors = [
          "logind"
          "systemd"
        ];
        disabledCollectors = [ "textfile" ];
        openFirewall = true;
        firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
      };

      postgres = lib.optionalAttrs config.services.postgresql.enable {
        enable = true;
        listenAddress = "0.0.0.0";
        port = 9187;
      };
    };
  };
}
