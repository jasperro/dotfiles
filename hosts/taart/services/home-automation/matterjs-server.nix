{
  jdf.hosts._.taart._.services._.home-automation._.matterjs-server.nixos =
    { ... }:
    {
      systemd.tmpfiles.settings."10-matterjs-server" = {
        "/var/lib/matterjs-server".d = {
          mode = "0750";
          user = "root";
          group = "root";
        };
      };

      networking.firewall.allowedTCPPorts = [
        5540 # Matter default commissioning/communication port
        5580 # Matter.js server WebSocket API / Web UI port
      ];
      networking.firewall.allowedUDPPorts = [
        5540 # Matter default mDNS/UDP communication port
        5353 # mDNS port for local discovery
      ];

      virtualisation.oci-containers.containers.matterjs-server = {
        volumes = [
          "/var/lib/matterjs-server:/data"
        ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        autoStart = true;
        image = "ghcr.io/matter-js/matterjs-server:latest";
        extraOptions = [
          "--network=host"
        ];
      };
    };
}
# {
#   jdf.hosts._.taart._.services._.home-automation._.matterjs-server.nixos =
#     { config, pkgs, ... }:
#     {
#       # Enable the native NixOS matterjs-server service
#       services.matterjs-server = {
#         enable = true;

#         # Opens default firewall ports automatically when set to true
#         openFirewall = true;

#         # Optional: Specify additional service configuration if needed
#         # port = 5580;
#         # storagePath = "/var/lib/matterjs-server";
#       };

#       # Optional: Explicit firewall configuration if you prefer strictly controlling ports manually
#       # instead of relying on `openFirewall = true;`
#       # networking.firewall = {
#       #   allowedTCPPorts = [ 5540 5580 ];
#       #   allowedUDPPorts = [ 5540 5353 ];
#       # };
#     };
# }
