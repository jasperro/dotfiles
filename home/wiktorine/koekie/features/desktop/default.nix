{ pkgs, config, ... }:
{
  # services.kdeconnect.enable = true;
  home.packages = with pkgs; [
    kdePackages.kdeconnect-kde
    # general desktop apps
    vscode
    firefox-wayland
    gimp
    inkscape
    krita
    qalculate-qt
    ark

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

    # multimedia
    pavucontrol
    audacity
    vlc

    # games
    (lutris.override {
      extraPkgs = pkgs: [
        pkgs.mangohud
      ];
    })
    steam
    prismlauncher
  ];
}
