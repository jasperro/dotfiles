{
  lib,
  ...
}:
{

  imports = [
    ../../common
    ./features/cli
    ./features/editors/nixvim
    ./features/editors/vscode
  ];

  home = {
    username = lib.mkDefault "jasperro";
  };
}
