{
  lib,
  ...
}:
{

  imports = [
    ../../common
    ./features/cli
    ./features/editors/nixvim
  ];

  home = {
    username = lib.mkDefault "jasperro";
  };
}
