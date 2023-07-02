{
  services.nginx.virtualHosts."home.albering.nl" = {
    useACMEHost = "*.albering.nl";
    forceSSL = true;
    extraConfig = ''
      proxy_buffering off;
    '';
    locations."/".extraConfig = ''
      proxy_pass http://127.0.0.1:8123;
      proxy_set_header Host $host;
      proxy_redirect http:// https://;
      proxy_http_version 1.1;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    '';
    locations."/bitwarden/".extraConfig = ''
      proxy_pass http://127.0.0.1:7277;
      proxy_set_header Host $host;
      proxy_redirect http:// https://;
      proxy_http_version 1.1;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    '';
    locations."~* /bitwarden/admin$".extraConfig = ''
      deny all;
      allow 192.168.1.0/24;

      proxy_pass http://127.0.0.1:7277;
      proxy_set_header Host $host;
      proxy_redirect http:// https://;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    '';
  };
}
