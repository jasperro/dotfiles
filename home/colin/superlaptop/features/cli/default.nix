{ pkgs, ... }: {
  imports = [
    ../../../../common/features/cli/jasperro-shell.nix
    ./git.nix
  ];
  home.packages = with pkgs; [
    distrobox
    ncdu
    # nodePackages.wrangler
  ];
}

