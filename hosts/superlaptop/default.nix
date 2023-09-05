# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd
    ../common/nixos
    ../common/nixos/home-locale.nix
    ../common/nixos/nix-alien.nix
    ../common/services/openssh-inbound.nix
    ../common/desktop/kde-sddm-wayland.nix

    ./hardware-configuration.nix
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  hardware = {
    opengl = {
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
  };

  # Only *.enable, otherwise split to file in services/
  services = {
    flatpak.enable = true;
  };

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
    tmp.useTmpfs = true;
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "i2c-dev" ];
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

  users.groups.colin.gid = 1002;

  home-manager.users.colin = import ../../home/colin/superlaptop;

  users.users = {
    colin = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      uid = 1001;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = [ "http" "docker" "i2c" "video" "uucp" "kvm" "audio" "wheel" "colin" ];
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
