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
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    ./hardware-configuration.nix
  ];

  networking.hostName = "doosje";

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
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
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  fileSystems =
    {
      "/".options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" ];
      "/home".options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" ];
      "/nix".options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" ];
      "/.snapshots".options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" ];
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
          options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" "subvol=bestanden" ];
        };
    };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        extraEntries = {
          "arch-zen.conf" = ''
            title              Arch Linux Zen
            linux              /vmlinuz-linux-zen
            initrd             /amd-ucode.img
            initrd             /booster-linux-zen.img
            options            root=UUID=783850d4-b511-46e4-a690-11aceed00e7d rootflags=subvol=archroot rw pcie_aspm=off apparmor=1 lsm=lockdown,yama,apparmor
          '';
        };
      };
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    numDevices = 1;
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.portal.enable = true;
  # xdg.portal.gtkUsePortal = true;
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "terminate:ctrl_alt_bksp";
    videoDrivers = [ "amdgpu" ];
    displayManager.sddm.enable = true;
    displayManager.sddm.settings = { Theme = { CursorTheme = "breeze_cursors"; }; };
    desktopManager.plasma5.enable = true;
    desktopManager.plasma5.supportDDC = true;
  };

  # OpenCL
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # Vulkan
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      25565 # Minecraft server
    ];
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
  };

  environment.systemPackages = with pkgs; [
    # general tools
    acpi
    acpid
    arp-scan
    youtube-dl
    wget
    wget2
    w3m
    sloccount
    screen
    nnn
    neofetch
    meld

    zoxide
    silver-searcher
    ripgrep

    # (de)compression
    zip
    unzip
    p7zip

    sshfs
  ];


  services.avahi = {
    nssmdns = true;
    enable = true;
    ipv4 = true;
    ipv6 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
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
      extraGroups = [ "http" "minecraft" "docker" "i2c" "users" "video" "uucp" "kvm" "audio" "wheel" "jasperro" ];
      shell = pkgs.zsh;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
