{ pkgs, ... }: {
  imports = [
    ../../../../common/features/cli/jasperro-zsh.nix
    ./git.nix
  ];
  home.packages = with pkgs; [
    distrobox

    ncdu
    exa
    ripgrep
    httpie
    jq
    gnupg
  ];
  programs.fzf = {
    enable = true;
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
