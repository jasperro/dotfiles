{
  imports = [ ../common/nixos/networking.nix ];

  networking.hostName = "taart";

  networking.firewall = {
    enable = true;
  };

  # For LXC/systemd-nspawn
  networking.useHostResolvConf = false;
}
