{ pkgs, ... }: {
  imports = [
    ../../../../common/features/cli/jasperro-shell.nix
  ];
  home.packages = with pkgs; [
  ];
}

