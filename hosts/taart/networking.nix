{
  imports = [ ../common/nixos/networking.nix ];

  networking.hostName = "taart";

  networking.interfaces.end0.useDHCP = true;

  networking.firewall = {
    enable = true;
  };
}
