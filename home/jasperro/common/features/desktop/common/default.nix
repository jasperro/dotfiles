{ pkgs, ... }:
{
  # services.kdeconnect.enable = true;
  home.packages = with pkgs; [
    # in wayland wm, still use some kde packages
    kdePackages.kdeconnect-kde
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ark
    kdePackages.kate
    kdePackages.gwenview
    kdePackages.konsole

    # general desktop apps
    #sandboxed-firefox-wayland
    firefox-wayland
    chromium
    #firefox-devedition-bin
    arduino
    alacritty
    # thunderbird
    # tdesktop
    # teamspeak_client
    # teams
    # sidequest
    obsidian
    # wireshark
    gimp3
    # discord
    # blender
    inkscape
    qalculate-qt

    # Development
    # jetbrains.rider
    # dotnet-sdk_8

    # jetbrains.webstorm
    # android-studio

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
    (lutris.override {
      extraPkgs = pkgs: [
        pkgs.mangohud
      ];
    })
    steam
    heroic
    superTux
    superTuxKart
    prismlauncher

    # LaTeX
    # texlive.combined.scheme-medium

    filezilla
    aseprite
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";
  };
}
