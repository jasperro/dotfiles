{
  imports = [
    ./acme.nix
  ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    # defaultHTTPListenPort = 80;
    # defaultSSLListenPort = 443;
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
