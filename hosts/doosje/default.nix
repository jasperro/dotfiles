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
    ../common/nixos/home-locale.nix
    ../common/nixos/nix-alien.nix
    ../common/desktop/kde-sddm-wayland.nix

    ./hardware-configuration.nix
    ./networking.nix
  ];

  hardware = {
    amdgpu = {
      loadInInitrd = true;
      opencl = true;
    };
  };

  # Only *.enable, otherwise split to file in services/
  services = {
    ratbagd.enable = true;
    flatpak.enable = true;
    fwupd.enable = true;
  };

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

  nixpkgs = {
    # You can add overlays here
    overlays = [ inputs.nix-minecraft.overlay ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    priority = 10;
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
      extraGroups = [
        "http"
        "minecraft"
        "docker"
        "podman"
        "i2c"
        "users"
        "video"
        "uucp"
        "kvm"
        "audio"
        "wheel"
        "usershares"
        "jasperro"
      ];
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
