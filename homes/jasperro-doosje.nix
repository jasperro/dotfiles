{ __findFile, ... }:
{
  den.aspects.jasperro-doosje = {
    includes = [
      <JDF/users/jasperro/desktop/niri>
      <JDF/users/jasperro/desktop-packages>
      <JDF/users/jasperro/git>
      <JDF/users/jasperro/cli>

      <JDF/users/jasperro/editors/nixvim>
      <JDF/users/jasperro/editors/vscode>
    ];

    homeManager =
      { pkgs, ... }:
      {
        key = "jasperro-doosje";
        stylix = {
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
        };
      };
  };
}
