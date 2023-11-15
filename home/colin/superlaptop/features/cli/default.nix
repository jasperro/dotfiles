{ pkgs, ... }: {
  imports = [
    ../../../../common/features/cli/jasperro-zsh.nix
    ./git.nix
  ];
  home.packages = with pkgs; [
    distrobox
    ncdu
    # nodePackages.wrangler
  ];
}

