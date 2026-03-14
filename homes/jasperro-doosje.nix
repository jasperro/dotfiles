{ __findFile, ... }:
{
  den.homes.x86_64-linux.jasperro-doosje = {
    description = "Standalone home configuration for jasperro's desktop computer.";
    aspect = "jasperro-doosje";
  };

  den.aspects.jasperro-doosje = {
    includes = [
      <JDF/users/jasperro/desktop/niri>
      <JDF/users/jasperro/desktop-packages>
      <JDF/users/jasperro/git>
      <JDF/users/jasperro/cli>

      <JDF/users/jasperro/editors/nixvim>
      <JDF/users/jasperro/editors/vscode>
    ];
  };
}
