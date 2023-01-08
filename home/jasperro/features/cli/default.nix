{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./git.nix
  ];
  home.packages = with pkgs; [
    distrobox

    ncdu
    exa
    ripgrep
    httpie
    jq
  ];
  programs.fzf = {
    enable = true;
  };
}
