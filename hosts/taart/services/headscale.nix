{ jdf, ... }: {
  jdf.hosts._.taart._.services._.headscale.nixos =
    {
      pkgs,
      host,
      ...
    }:
    let
      cfg = host.settings.services.headscale;
      headscaleAcl = {
        groups = {
          "group:admin" = [ "jasperro" ];
        };
        hosts = {
          "pi" = "192.168.1.16/32";
          "camera" = "192.168.1.31/32";
        };
        acls = [
          {
            action = "accept";
            src = [ "group:admin" ];
            dst = [ "pi:*" ];
          }
          {
            action = "accept";
            src = [ "group:admin" ];
            dst = [ "camera:*" ];
          }
        ];
      };

      aclJsonFile = pkgs.writeText "headscale-acl.json" (builtins.toJSON headscaleAcl);
    in
    {
      systemd.tmpfiles.rules = [
        "d /etc/headscale 0755 headscale headscale -"
        "L+ /etc/headscale/acl.json - - - - ${aclJsonFile}"
      ];

      services.headscale = {
        enable = true;
        port = cfg.port;

        settings = {
          server_url = cfg.url;
          listen_addr = "127.0.0.1:${toString cfg.port}";

          ip_prefixes = [
            "100.64.0.0/10"
          ];

          # Points to the symlinked ACL file created by systemd-tmpfiles
          policy = {
            mode = "file";
            path = "/etc/headscale/acl.json";
          };

          derp.server.enabled = false;
        };
      };

      # 4. Tailscale Subnet Router & IP Forwarding
      services.tailscale.enable = true;

      boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

      services.nginx.virtualHosts."${cfg.host}" = {
        useACMEHost = "albering";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 1d;
            proxy_send_timeout 1d;
          '';
        };
      };
    };
}
