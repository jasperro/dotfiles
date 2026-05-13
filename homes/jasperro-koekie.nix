{ __findFile, ... }:
{
  den.aspects.jasperro-koekie = {
    includes = [
      <JDF/users/jasperro/git>
      <JDF/users/jasperro/cli>
    ];
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
