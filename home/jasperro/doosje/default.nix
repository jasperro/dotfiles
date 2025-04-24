# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, config, ... }:
{
  # You can import other home-manager modules here
  imports = [
    ../common
    ../common/features/desktop/common
  ];

  colorscheme = inputs.nix-colors.colorschemes.gruvbox-dark-hard;
  wallpaper = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.currentwallpaper";

  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      workspace = "1";
      primary = true;
    }
  ];
}
