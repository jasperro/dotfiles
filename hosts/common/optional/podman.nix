{ pkgs, ... }:
{
  # Deterministic naming patch
  options.virtualisation.oci-containers.config = lib.mkIf (cfg.containers != { }) (lib.mkMerge [
    {
      systemd.services = mapAttrs' (n: v: nameValuePair "oci-${n}" (mkService n v)) cfg.containers;
    }
    (lib.mkIf (cfg.backend == "podman") {
      virtualisation.podman.enable = true;
    })
    (lib.mkIf (cfg.backend == "docker") {
      virtualisation.docker.enable = true;
    })
  ]);

  virtualisation = {
    podman = {
      enable = true;

      dockerCompat = true;
      dockerSocket.enable = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    crun
    fuse-overlayfs
  ];

  environment.sessionVariables = {
    # DOCKER_HOST = "unix:///var/run/podman/podman.sock";
    # TODO: Do this in home manager config
    DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
  };
}
