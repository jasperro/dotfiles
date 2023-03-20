{ pkgs, config, ... }:
{
  # services.kdeconnect.enable = true;
  home.packages = with pkgs; [
    plasma5Packages.kdeconnect-kde
    # general desktop apps
    vscode
    firefox-wayland
    #firefox-devedition-bin
    arduino
    alacritty
    teams
    gimp
    discord
    inkscape
    qalculate-qt
    ark
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
    gnome.dconf-editor
    gparted

    # wine
    wine-wayland
    winetricks

    # theming
    gnome3.adwaita-icon-theme
    papirus-icon-theme
    breeze-gtk

    # multimedia
    pavucontrol
    audacity
    vlc

    # games
    lutris
    steam
    prismlauncher

    # LaTeX
    # texlive.combined.scheme-medium
  ];
}
