{ pkgs, config, ... }:
{
  # services.kdeconnect.enable = true;
  home.packages = with pkgs; [
    kdePackages.kdeconnect-kde
    # general desktop apps
    vscode
    #sandboxed-firefox-wayland
    firefox-wayland
    chromium
    #firefox-devedition-bin
    arduino
    alacritty
    thunderbird
    tdesktop
    teamspeak_client
    #teams
    sidequest
    obsidian
    wireshark
    gimp
    discord
    blender
    inkscape
    qalculate-qt
    ark

    # Development
    jetbrains.rider
    dotnet-sdk_8

    jetbrains.webstorm
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

    dconf
    dconf-editor
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
    superTux
    superTuxKart
    prismlauncher

    # LaTeX
    texlive.combined.scheme-medium

    filezilla
    aseprite
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";
  };
}
