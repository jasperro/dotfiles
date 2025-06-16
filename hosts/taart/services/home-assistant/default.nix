{ oci-images, ... }:
{
  imports = [
    ../podman.nix
    ../nginx.nix
    ./mosquitto.nix
    ./zigbee2mqtt
    ./vaultwarden.nix
    ./mariadb.nix
    ./esphome.nix
    ./appdaemon.nix
    ./grott
    # ./appdaemon.nix
  ];

  virtualisation.oci-containers.containers.homeassistant = {
    inherit (oci-images.home-assistant) image imageFile;
    autoStart = true;
    volumes = [
      "/var/lib/hass/homeassistant:/config"
      "/etc/localtime:/etc/localtime:ro"
      "/run/mysqld/mysqld.sock:/run/mysqld/mysqld.sock"
    ];
    environment.TZ = "Europe/Amsterdam";
    extraOptions = [
      "--network=host"
      # "--device=/dev/ttyACM0:/dev/ttyACM0"
      # DO NOT USE THIS OUTSIDE LXC
      # "--privileged"
    ];
    # ports = [
    #   # Temp overlap due to LXC
    #   "8124:8123"
    # ];
  };

  # let
  #   cgroupSubsystems = [
  #     "blkio"
  #     "cpu,cpuacct"
  #     "cpuset"
  #     "devices"
  #     "memory"
  #     "net_cls,net_prio"
  #     "freezer"
  #     "hugetlb"
  #     "perf_event"
  #     "pids"
  #     "rdma"
  #     "misc"
  #   ];
  # in
  # fileSystems =
  #   lib.listToAttrs (
  #     map (name: {
  #       name = "/sys/fs/cgroup/${name}";
  #       value = {
  #         device = "cgroup";
  #         fsType = "cgroup";
  #         options = [
  #           name
  #           "rw"
  #         ];
  #         neededForBoot = true;
  #       };
  #     }) cgroupSubsystems
  #   )
  #   // {
  #     "/sys/fs/cgroup" = {
  #       device = "cgroup";
  #       fsType = "cgroup2";
  #       options = [ "rw" ];
  #       neededForBoot = true;
  #     };
  #   };

  systemd.services."podman-homeassistant" = {
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
