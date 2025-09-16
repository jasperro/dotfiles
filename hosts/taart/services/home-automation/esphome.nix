let
  port = 6052;
in
{
  imports = [ ../nginx.nix ];
  services.esphome = {
    # Not a setting, id systemd DynamicUser so in /var/lib/private/esphome
    # stateDir = "/var/lib/esphome";
    enable = true;
    # enableUnixSocket = true;
    inherit port;
    openFirewall = false;
  };

  # users.users.nginx.extraGroups = [ "esphome" ];

  # services.nginx.virtualHosts."home.albering.nl" = {
  #   locations."/esphome/".extraConfig = ''
  #     deny all;
  #     allow 192.168.1.0/24;

  #     proxy_pass http://unix:/run/esphome/esphome.sock;
  #     proxy_set_header Host $host;
  #     proxy_redirect http:// https://;
  #     proxy_http_version 1.1;
  #     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  #     proxy_set_header Upgrade $http_upgrade;
  #     proxy_set_header Connection $connection_upgrade;
  #   '';
  # };
}
