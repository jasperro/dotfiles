# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    ../common
  ];

  targets.genericLinux.enable = true;
}
