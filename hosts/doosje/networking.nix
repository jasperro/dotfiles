{
  imports = [ ../common/nixos/networking.nix ];

  networking.hostName = "doosje";

  networking.interfaces.enp3s0.useDHCP = true;

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };
}
