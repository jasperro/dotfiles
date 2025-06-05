{
  imports = [
    ../podman.nix
    ../nginx.nix
    ./mariadb.nix
  ];

  virtualisation.oci-containers.containers.homeassistant = {
    volumes = [
      "/var/lib/hass:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment.TZ = "Europe/Amsterdam";
    image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
    extraOptions = [
      "--network=host"
      "--device=/dev/ttyACM0:/dev/ttyACM0"
    ];
    dependsOn = [ "mysql.service" ];
  };

  systemd.services."podman-home-assistant" = {
    after = [ "mysql.service" ];
    requires = [ "mysql.service" ];
  };

  services.nginx.virtualHosts."home.albering.nl" = {
    locations."/".extraConfig = ''
      proxy_pass http://127.0.0.1:8123;
      proxy_set_header Host $host;
      proxy_redirect http:// https://;
      proxy_http_version 1.1;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
    '';
  };
}
