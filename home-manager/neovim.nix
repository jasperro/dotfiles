{ pkgs, lib, homeManagerModules, ... }:
{
  imports = [../modules/home-manager/astronvim.nix];
  astronvim.enable = true;

  home.packages = with pkgs; [
    neovim
    ripgrep
    gnumake
  ];
}
