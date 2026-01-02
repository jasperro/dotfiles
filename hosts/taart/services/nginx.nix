{
  imports = [
    ./acme.nix
  ];

  networking.firewall.allowedTCPPorts = [
    8443
    880
  ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    # recommendedProxySettings = true;
    recommendedOptimisation = true;
    defaultHTTPListenPort = 880;
    defaultSSLListenPort = 8443;
  };

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx.virtualHosts."home.albering.nl" = {
    useACMEHost = "albering";
    forceSSL = true;
    extraConfig = ''
      proxy_buffering off;
    '';
  };
}
