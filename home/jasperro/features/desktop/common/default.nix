{ pkgs, ... }:
{
  services.kdeconnect.enable = true;
  home.packages = with pkgs; [
    # general desktop apps
    vscode
    firefox-wayland
    #firefox-devedition-bin
    arduino
    alacritty
    thunderbird
    tdesktop
    teamspeak_client
    teams
    sidequest
    obsidian
    openrgb
    wireshark
    gimp
    discord
    blender
    inkscape
    qalculate-qt
    ark

    # Development
    config.nur.repos.utybo.jetbrains.rider
    config.nur.repos.utybo.jetbrains.webstorm
    android-studio

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
    piper

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
    superTux
    superTuxKart
    prismlauncher

    # LaTeX
    # texlive.combined.scheme-medium
  ];
}