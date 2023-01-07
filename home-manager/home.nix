# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    ./editors
    ./zsh.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "jasperro";
    homeDirectory = "/home/jasperro";
  };

  home.pointerCursor = { package = pkgs.breeze-icons; gtk.enable = true; name = "breeze_cursors"; size = 24; };

  # GTK config somehow breaks home-manager, maybe fix later?

  # gtk = {
  #   enable = true;
  #   theme = { package = pkgs.breeze-gtk; name = "Breeze"; };
  #   iconTheme = { package = pkgs.papirus-icon-theme; name = "Papirus Dark"; };
  # };

  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    exa

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

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.lesspipe.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
