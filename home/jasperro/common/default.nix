{ inputs, lib, pkgs, outputs, ... }: {

  imports = [
    ../../common
    ./features/cli
    ./features/editors/nixvim
  ];

  home = {
    username = lib.mkDefault "jasperro";
  };
}
