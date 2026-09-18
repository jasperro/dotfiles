{
  den,
  lib,
  jdf,
  jdfPath,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath {
    includes = [ jdf.hosts._.taart._.services._.acme ];
    nixos = {
      networking.firewall.allowedTCPPorts = [
        443
      ];

      services.nginx = {
        enable = true;
        recommendedTlsSettings = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
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
