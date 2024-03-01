{ pkgs, config, ... }:
{
  # services.kdeconnect.enable = true;
  home.packages = with pkgs; [
    kdePackages.kdeconnect-kde
    # general desktop apps
    firefox-wayland
    #firefox-devedition-bin
    gimp
    inkscape
    qalculate-qt
    ark

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
    vlc

    # games
    prismlauncher

    # LaTeX
    # texlive.combined.scheme-medium
  ];
}
