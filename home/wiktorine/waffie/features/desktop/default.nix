{ pkgs, ... }:
{
  # services.kdeconnect.enable = true;
  home.packages = with pkgs; [
    kdePackages.kdeconnect-kde
    # general desktop apps
    firefox-wayland
    #firefox-devedition-bin
    gimp3
    inkscape
    qalculate-qt
    kdePackages.ark

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
    prismlauncher

    # LaTeX
    # texlive.combined.scheme-medium
  ];
}
