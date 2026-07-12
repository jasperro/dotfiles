{
  den,
  lib,
  jdf,
  ...
}:
{
  jdf.hosts._.taart._.services._.nginx = {
    includes = [ jdf.hosts._.taart._.services._.acme ];
    nixos = {
      networking.firewall.allowedTCPPorts = [
        # 8443
        # 880
        443
        80
      ];

      services.nginx = {
        enable = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
        # recommendedProxySettings = true;
        recommendedOptimisation = true;
        # defaultHTTPListenPort = 880;
        # defaultSSLListenPort = 8443;
      };

      users.users.nginx.extraGroups = [ "acme" ];

      services.nginx.virtualHosts."home.albering.nl" = {
        useACMEHost = "albering";
        forceSSL = true;
        extraConfig = ''
          proxy_buffering off;
        '';
      };
    };
  };
}
