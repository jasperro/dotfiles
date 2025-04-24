{ pkgs, ... }:
{
  imports = [
    ../../../../common/features/cli/jasperro-shell.nix
    ./git.nix
  ];
  home.packages = with pkgs; [
    distrobox

    ripgrep
    httpie
    jq
    gnupg

    appimage-run
    gh

    nixd
    nixfmt-rfc-style
  ];
  programs.fzf = {
    enable = true;
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
