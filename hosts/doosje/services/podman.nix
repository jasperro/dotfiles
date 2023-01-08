{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;

      dockerCompat = true;
      dockerSocket.enable = true;

      defaultNetwork.dnsname.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
