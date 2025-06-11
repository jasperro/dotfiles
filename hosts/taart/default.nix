# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{
  inputs,
  outputs,
  pkgs,
  impurity,
  # modulesPath,
  # lib,
  ...
}:
{
  imports = [
    # "${modulesPath}/virtualisation/lxc-container.nix"
    inputs.home-manager.nixosModules.home-manager
    ./services
    ../common/nixos
    ../common/nixos/home-locale.nix

    # Disable all below for LXC
    inputs.hardware.nixosModules.raspberry-pi-4
    inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ./networking.nix
  ];

  # For LXC/systemd-nspawn
  # networking.useHostResolvConf = false;
  # networking.dhcpcd.enable = lib.mkForce false;

  # boot = {
  #   # tmp.useTmpfs = true;
  #   # LXC Stuff
  #   isContainer = true;
  #   loader.generic-extlinux-compatible.enable = false;
  # };

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs impurity; };
  home-manager.backupFileExtension = "hmbackup";

  sops.age.sshKeyPaths = [ "/home/jasperro/.ssh/id_ed25519" ];

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    priority = 10;
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  users.groups.jasperro.gid = 1000;

  home-manager.users.jasperro = import ../../home/jasperro/taart;

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
        "i2c"
        "users"
        "video"
        "uucp"
        "kvm"
        "audio"
        "wheel"
        "jasperro"
      ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPkTvmcxZ7h5afV6wOt96LUL5SjfLuvi0LSPGmOy4Gq jasperro@doosje"
        ];
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
