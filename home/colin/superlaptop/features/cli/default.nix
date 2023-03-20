{ pkgs, ... }: {
  home.packages = with pkgs; [
    distrobox
    ncdu
    nodePackages.wrangler
  ];
}

