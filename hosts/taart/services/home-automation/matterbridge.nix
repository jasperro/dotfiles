{
  JDF.hosts._.taart._.services._.home-automation._.matterbridge.nixos =
    { config, ... }:
    {
      key = "matterbridge";
      systemd.tmpfiles.settings."10-matterbridge" = {
        "/var/lib/matterbridge".d = {
          mode = "0750";
          user = "root";
          group = "root";
        };
        "/var/lib/matterbridge/Matterbridge".d = {
          mode = "0750";
          user = "root";
          group = "root";
        };
        "/var/lib/matterbridge/.matterbridge".d = {
          mode = "0750";
          user = "root";
          group = "root";
        };
        "/var/lib/matterbridge/.mattercert".d = {
          mode = "0750";
          user = "root";
          group = "root";
        };
      };

      networking.firewall.allowedTCPPorts = [
        5540
      ];
      networking.firewall.allowedUDPPorts = [
        5540
      ];

      virtualisation.oci-containers.containers.matterbridge = {
        volumes = [
          "/var/lib/matterbridge/Matterbridge:/root/Matterbridge"
          "/var/lib/matterbridge/.matterbridge:/root/.matterbridge"
          "/var/lib/matterbridge/.mattercert:/root/.mattercert"
        ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        autoStart = true;
        image = "registry.hub.docker.com/luligu/matterbridge:latest";
        extraOptions = [
          "--network=host"
        ];
        cmd = [
          "matterbridge"
          "--docker"
          "--frontend"
          "8482"
        ];
      };
    };
}
