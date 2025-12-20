# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ pkgs, ... }:
{
  # You can import other home-manager modules here
  imports = [
    ../../common
    ../../common/features/cli/jasperro-shell.nix
  ];

  home.username = "jasperro";
  home.packages = with pkgs; [
    waypipe
  ];
}
