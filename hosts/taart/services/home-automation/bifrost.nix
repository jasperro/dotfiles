{ config, lib, ... }:
{
  sops.templates."bifrost-config" =
    let
      bifrostConfig = {
        bifrost.cert_file = "certs/cert.pem";
        bifrost.state_file = "state/state.yaml";
        bridge = {
          name = "My Bifrost Bridge";
          mac = "DE:AD:BE:BE:EE:FF";
          ipaddress = "192.168.1.16";
          netmask = "255.255.255.0";
          gateway = "192.168.1.1";
          timezone = "Europe/Amsterdam";
        };

        z2m = {
          server1 = {
            url = "ws://localhost:1919/api?token=${config.sops.placeholder."zigbee2mqtt/auth_token"}";
          };
        };
      };
    in
    {
      content = lib.generators.toYAML { } bifrostConfig;
      mode = "0440";
    };

  systemd.tmpfiles.settings."10-bifrost" = {
    "/var/lib/bifrost".d = {
      mode = "0750";
      user = "root";
      group = "root";
    };
    "/var/lib/bifrost/certs".d = {
      mode = "0750";
      user = "root";
      group = "root";
    };
    "/var/lib/bifrost/config.yaml"."L+" = {
      argument = config.sops.templates.bifrost-config.path;
    };
    # state dir instead of file, because bifrost creates the file itself (and is angry when it gets an empty state file)
    "/var/lib/bifrost/state".d = {
      mode = "0640";
      user = "root";
      group = "root";
    };
  };

  virtualisation.oci-containers.containers.bifrost = {
    image = "ghcr.io/chrivers/bifrost:latest";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    autoStart = true;
    volumes = [
      "/var/lib/bifrost/config.yaml:/app/config.yaml:ro"
      "/var/lib/bifrost/state:/app/state:rw"
      "/var/lib/bifrost/certs:/app/certs:rw"
    ];
    extraOptions = [
      "--network=host"
    ];
    ports = [
      "80:80"
      "443:443"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  systemd.services."podman-bifrost" = {
    after = [ "zigbee2mqtt.service" ];
    requires = [ "zigbee2mqtt.service" ];
  };
}
