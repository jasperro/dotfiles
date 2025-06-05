{ pkgs, lib, ... }:
{
  virtualisation = {
    oci-containers = {
      backend = lib.mkForce "podman";
    };
    podman = {
      enable = true;

      dockerCompat = true;
      dockerSocket.enable = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
