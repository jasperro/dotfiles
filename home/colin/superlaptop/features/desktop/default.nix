{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kdePackages.kdeconnect-kde
    # general desktop apps
    vscode
    firefox-wayland
    #firefox-devedition-bin
    arduino
    alacritty
    #teams
    gimp3
    discord
    inkscape
    qalculate-qt
    kdePackages.ark
    cool-retro-term
    obs-studio

    # Office
    libreoffice
    hyphen
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_nl

    # X/Wayland utilities
    x11_ssh_askpass
    xorg.xeyes
    wl-clipboard
    wl-clipboard-x11
    waypipe
    waynergy
    wev

    dconf
    dconf-editor
    gparted

    # wine
    wine-wayland
    winetricks

    # multimedia
    pavucontrol
    vlc

    # games
    lutris
    steam
    prismlauncher

    # LaTeX
    # texlive.combined.scheme-medium
  ];
}
