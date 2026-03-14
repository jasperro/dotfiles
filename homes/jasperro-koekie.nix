{ __findFile, ... }:
{
  den.aspects.jasperro-koekie = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          waypipe
        ];
      };
  };
}
