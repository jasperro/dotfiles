# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, ... }:
{
  # You can import other home-manager modules here
  imports = [
    ../common
    ../common/features/desktop/common
    ../common/features/desktop/hyprland
  ];

  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;

  monitors = [
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 180;
      workspace = "1";
      primary = true;
    }
  ];
}
