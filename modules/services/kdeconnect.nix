let
  key = "kdeconnect";
in
{
  JDF.services._.kdeconnect = {
    nixos = {
      inherit key;
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
        inherit key;
        home.packages = [
          pkgs.kdePackages.kdeconnect-kde
        ];
      };
  };
}
