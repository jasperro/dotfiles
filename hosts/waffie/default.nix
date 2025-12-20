# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{
  inputs,
  outputs,
  pkgs,
  impurity,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    ../common/nixos
    ../common/nixos/home-locale.nix
    ../common/nixos/nix-alien.nix
    ../common/services/openssh-inbound.nix
    ../common/desktop/kde-sddm-wayland.nix

    ./hardware-configuration.nix
    ./networking.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs impurity; };

  hardware = {
    graphics = {
      enable = true;
    };
    bluetooth.enable = true;
  };

  programs.gamemode.enable = true;

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
    "/.snapshots".options = [
      "rw"
      "noatime"
      "compress=zstd:3"
      "ssd"
    ];
    "/var".options = [
      "rw"
      "noatime"
      "compress=zstd:3"
      "ssd"
    ];
    "/boot".options = [
      "rw"
      "utf8"
    ];
  };

  boot = {
    tmp.useTmpfs = true;
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "i2c-dev" ];
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
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    priority = 10;
  };

  users.groups.wiktorine.gid = 1003;

  home-manager.users.wiktorine = import ../../home/wiktorine/waffie;

  users.users = {
    wiktorine = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = [
        "http"
        "docker"
        "i2c"
        "video"
        "uucp"
        "kvm"
        "audio"
        "wheel"
        "wiktorine"
      ];
      shell = pkgs.zsh;
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
