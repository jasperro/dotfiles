# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ pkgs, ... }:
{
  # You can import other home-manager modules here
  imports = [
    ../common
    ../common/features/desktop/common
    ./features/desktop/hyprland
  ];

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      workspace = "1";
      primary = true;
    }
  ];

  stylix = {
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  };
}
