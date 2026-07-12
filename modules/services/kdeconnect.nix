let
in
{
  JDF.services._.kdeconnect = {
    nixos = {
      networking.firewall = {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
      };
    };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.kdePackages.kdeconnect-kde
        ];
      };
  };
}
