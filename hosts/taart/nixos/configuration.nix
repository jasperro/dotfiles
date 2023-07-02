# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    ../services

    # ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      # A lot GUI programs need this, nearly all wayland applications
      # "cma=128M"
      "dtparam=audio=on"
    ];
  };

  boot.loader.raspberryPi = {
    enable = true;
    version = 4;
    # Surpress missing SD card errors
    firmwareConfig = "dtparam=sd_poll_once=on";
  };
  boot.loader.grub.enable = false;

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "taart";

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

  fileSystems =
    {
      "/".options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" ];
      "/home".options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" ];
      "/nix".options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" ];
      "/.snapshots".options = [ "rw" "noatime" "compress=zstd:3" "ssd" "space_cache" ];
      "/boot".options = [ "rw" "relatime" "fmask=0022" "dmask=0022" "codepage=437" "iocharset=iso8859-1" "shortname=mixed" "utf8" "errors=remount-ro" ];
    };

  nixpkgs = {
    # You can add overlays here
    overlays = [ ];
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.portal.enable = true;
  # networking.networkmanager.enable = true;

  # Vulkan
  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    libraspberrypi

    # general tools
    arp-scan
    youtube-dl
    wget
    wget2
    w3m
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


  services = {
    avahi = {
      nssmdns = true;
      enable = true;
      ipv4 = true;
      ipv6 = true;
      publish = {
        enable = true;
        addresses = true;
        # workstation = true;
      };
    };
    timesyncd.enable = true;

    fstrim.enable = true;
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

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # Free up to 1GiB whenever there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
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
      extraGroups = [ "http" "docker" "i2c" "users" "video" "uucp" "kvm" "audio" "wheel" "jasperro" ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPkTvmcxZ7h5afV6wOt96LUL5SjfLuvi0LSPGmOy4Gq jasperro@doosje"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFEZSIDsTBrON9sKhoq21EM7kRrO5MGcADcfjRiBAba jasperro@atoll"
        ];
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
