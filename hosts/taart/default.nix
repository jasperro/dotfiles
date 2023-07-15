# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    # inputs.hardware.nixosModules.raspberry-pi-4
    # inputs.hardware.nixosModules.common-pc-ssd
    ./services
    ../common/nixos
    ../common/nixos/home-locale.nix
    # ./hardware-configuration.nix (Not needed for LXC container)
    # ./networking.nix      (LXC container does not support networking.nix)
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  # hardware = {
  #   raspberry-pi."4".audio.enable = true;
  # };

  boot = {
    # tmp.useTmpfs = true;
    isContainer = true;
  };

  # zramSwap = {
  #   enable = true;
  #   memoryPercent = 40;
  #   priority = 10;
  # };

  # environment.systemPackages = with pkgs; [
  #   libraspberrypi
  # ];

  users.groups.jasperro.gid = 1000;

  users.users = {
    jasperro = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = [ "http" "i2c" "users" "video" "uucp" "kvm" "audio" "wheel" "jasperro" ];
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
