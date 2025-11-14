{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # general desktop apps
    vscode
    firefox
    qalculate-qt
    kdePackages.ark

    # Office
    libreoffice
    hyphen
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_nl

    # X/Wayland utilities
    x11_ssh_askpass
    wl-clipboard
    wl-clipboard-x11

    gparted
  ];
}
