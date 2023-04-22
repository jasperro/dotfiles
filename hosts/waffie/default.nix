# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    ../common/nixos
    ../common/optional/openssh-inbound.nix
    ../common/optional/nix-alien.nix

    ./hardware-configuration.nix
  ];

  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        intel-ocl # OpenCL
      ];
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
  };

  networking.hostName = "waffie";

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "nl_NL.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "nl_NL.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.gamemode.enable = true;

  fileSystems =
    {
      "/".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/home".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/nix".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/.snapshots".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/var".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/boot".options = [ "rw" "utf8" ];
    };

  boot = rec {
    kernelPackages = pkgs.linuxPackages_zen;
    extraModulePackages = [ kernelPackages.ddcci-driver ];
    kernelModules = [ "i2c-dev" "ddcci_backlight" ];
    supportedFilesystems = [ "ntfs" ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 6;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    priority = 10;
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      iosevka
      dejavu_fonts
      fira-code
      fira-code-symbols
      fira-mono
      fira
      ubuntu_font_family
      source-code-pro
      source-serif-pro
      source-sans-pro
      roboto
      roboto-mono
      jetbrains-mono
      terminus_font
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif = [ "Source Serif Pro" ];
      };
    };
  };

  xdg.portal.enable = true;
  # xdg.portal.gtkUsePortal = true;
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "terminate:ctrl_alt_bksp";
    displayManager = {
      sddm.enable = true;
      sddm.settings = { Theme = { CursorTheme = "breeze_cursors"; }; };
      defaultSession = "plasmawayland";
    };
    desktopManager.plasma5.enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };

  services.avahi = {
    nssmdns = true;
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      domain = true;
      hinfo = true;
      userServices = true;
    };
    openFirewall = true;
  };

  users.groups.wiktorine.gid = 1003;

  programs.zsh.enable = true;

  users.users = {
    wiktorine = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = [ "http" "docker" "i2c" "video" "uucp" "kvm" "audio" "wheel" "wiktorine" ];
      shell = pkgs.zsh;
      subUidRanges = [
        { startUid = 100000; count = 65536; }
      ];
      subGidRanges = [
        { startGid = 100000; count = 65536; }
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
