{ pkgs, ... }: {
  imports = [
    ../../../../common/features/cli/jasperro-zsh.nix
  ];
  home.packages = with pkgs; [
  ];
}

