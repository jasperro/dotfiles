{
  imports = [
    ./acme.nix
  ];
  services.nginx.virtualHosts."home.albering.nl" = {
    useACMEHost = "*.albering.nl";
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    forceSSL = true;
    extraConfig = ''
      proxy_buffering off;
    '';
  };
}
