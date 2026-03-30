{ __findFile, ... }:
{
  den.aspects.jasperro-koekie = {
    homeManager =
      { pkgs, ... }:
      {
        key = "jasperro-koekie";
        home.packages = with pkgs; [
          waypipe
        ];
      };
  };
}
