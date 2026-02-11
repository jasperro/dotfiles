# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{
  inputs,
  outputs,
  pkgs,
  impurity,
  ...
}:
let
  userMapping = pkgs.writeText "UserMapping" ''
    jasperro:jasperro:S-1-5-21-755346402-1880689631-2350194957-1002
  '';
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
    ./services
    ../common/nixos
    ../common/nixos/home-locale.nix
    ../common/nixos/nix-alien.nix
    ../common/desktop/hyprland.nix
    # ../common/desktop/niri.nix

    ./hardware-configuration.nix
    ./networking.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs impurity; };
  home-manager.backupFileExtension = "hmbackup";

  hardware = {
    graphics = {
      enable = true;
    };
    amdgpu = {
      opencl.enable = true;
    };
    xone.enable = true;
  };

  services.wivrn = {
    enable = true;
    openFirewall = true;
    defaultRuntime = true;
    autoStart = true;
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Only *.enable, otherwise split to file in services/
  services = {
    ratbagd.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
    hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };
    #    ollama = {
    #      enable = true;
    #      acceleration = "rocm";
    #      package = pkgs.ollama;
    #    };
  };

  programs.gamemode.enable = true;

  # Overclock gpu support
  # programs.corectrl = {
  #   enable = true;
  #   gpuOverclock = {
  #     enable = true;
  #     ppfeaturemask = "0xffffffff";
  #   };
  # };

  fileSystems = {
    "/".options = [
      "rw"
      "noatime"
      "compress=zstd:3"
      "ssd"
    ];
    "/home".options = [
      "rw"
      "noatime"
      "compress=zstd:3"
      "ssd"
    ];
    "/nix".options = [
      "rw"
      "noatime"
      "compress=zstd:3"
      "ssd"
    ];
    "/boot".options = [
      "rw"
      "relatime"
      "fmask=0022"
      "dmask=0022"
      "codepage=437"
      "iocharset=iso8859-1"
      "shortname=mixed"
      "utf8"
      "errors=remount-ro"
    ];

    "/media/Windows10" = {
      device = "/dev/disk/by-uuid/14743E80743E64A0";
      fsType = "ntfs";
      options = [
        "defaults"
        "rw"
        "noatime"
        "usermapping=${userMapping}"
      ];
    };

    "/media/OldSSD" = {
      device = "/dev/disk/by-uuid/7bf18a03-c38b-427f-b0be-fa7eb5d18643";
      fsType = "btrfs";
      options = [
        "rw"
        "noatime"
        "compress=zstd:3"
        "ssd"
        "subvol=bestanden"
      ];
    };
  };

  boot = {
    tmp.useTmpfs = true;
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "i2c-dev" ];
    kernelParams = [ "amd_pstate.shared_mem=1" ];
    supportedFilesystems = [ "ntfs" ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 6;
        consoleMode = "max";
        netbootxyz.enable = true;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    binfmt.preferStaticEmulators = true;
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [ ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    priority = 10;
  };

  users.groups.jasperro.gid = 1000;

  home-manager.users.jasperro = import ../../home/jasperro/doosje;

  users.users = {
    jasperro = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      group = "jasperro";
      extraGroups = [
        "wheel"
        "http"
        "minecraft"
        "docker"
        "podman"
        "video"
        "uucp"
        "dialout"
        "kvm"
        "audio"
      ];
      shell = pkgs.zsh;
      # shell = pkgs.nushell;
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
