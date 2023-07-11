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
    ../common/optional/desktop/kde-sddm-wayland.nix

    ./hardware-configuration.nix
    ./networking.nix
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

  users.groups.wiktorine.gid = 1003;

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
