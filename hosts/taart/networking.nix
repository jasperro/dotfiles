{
  imports = [ ../common/nixos/networking.nix ];

  networking.hostName = "taart";

  networking.firewall = {
    enable = true;
  };
}
