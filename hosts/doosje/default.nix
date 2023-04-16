# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }:
let
  userMapping = pkgs.writeText "UserMapping"
    ''
      jasperro:jasperro:S-1-5-21-755346402-1880689631-2350194957-1002
    '';
in
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    ./services
    ../common/nixos
    ../common/optional/nix-alien.nix
    ../common/optional/haskell.nix

    ./hardware-configuration.nix
  ];

  hardware = {
    amdgpu = {
      loadInInitrd = true;
      opencl = true;
    };
  };

  networking.hostName = "doosje";

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  networking.interfaces.enp3s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "nl_NL.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire =
    let
      defaultContextModules = (lib.importJSON "${inputs.nixpkgs}/nixos/modules/services/desktops/pipewire/daemon/pipewire.conf.json")."context.modules";
    in {
    enable = true;
    # config.pipewire = {
    #   "context.modules" = [{
    #     name = "libpipewire-module-roc-sink";
    #     args =  {
    #       fec.code = "disable";
    #       remote.ip = "192.168.1.216";
    #       remote.source.port = 10001;
    #       remote.repair.port = 10002;
    #       sink.name = "ROC Sink";
    #       sink.props = {
    #          node.name = "roc-sink";
    #       };
    #     };
    #   }
    #   ] ++ defaultContextModules;
    # };

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.ratbagd.enable = true;

  programs.gamemode.enable = true;

  # Overclock gpu support
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };

  fileSystems =
    {
      "/".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/home".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/nix".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/.snapshots".options = [ "rw" "noatime" "compress=zstd:3" "ssd" ];
      "/boot".options = [ "rw" "relatime" "fmask=0022" "dmask=0022" "codepage=437" "iocharset=iso8859-1" "shortname=mixed" "utf8" "errors=remount-ro" ];

      "/media/Windows10" =
        {
          device = "/dev/disk/by-uuid/14743E80743E64A0";
          fsType = "ntfs";
          options = [ "defaults" "rw" "noatime" "usermapping=${userMapping}" ];
        };

      "/media/OldSSD" =
        {
          device = "/dev/disk/by-uuid/7bf18a03-c38b-427f-b0be-fa7eb5d18643";
          fsType = "btrfs";
          options = [ "rw" "noatime" "compress=zstd:3" "ssd" "subvol=bestanden" ];
        };
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

  nixpkgs = {
    # You can add overlays here
    overlays = [ inputs.nix-minecraft.overlay ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    priority = 10;
  };

  fonts = {
    enableDefaultFonts = true;
    optimizeForVeryHighDPI = true;
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
    dpi = 108;
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

  services.resolved.enable = true;

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

  users.groups.jasperro.gid = 1000;

  users.users = {
    jasperro = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = [ "http" "minecraft" "docker" "podman" "i2c" "users" "video" "uucp" "kvm" "audio" "wheel" "usershares" "jasperro" ];
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
