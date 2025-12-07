# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ pkgs, ... }:
{
  # You can import other home-manager modules here
  imports = [
    ../common
    ../common/features/editors/vscode
    ../common/features/desktop/common
    ../common/features/desktop/hyprland
    # ../common/features/desktop/niri
  ];

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

  stylix = {
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/penumbra-dark-contrast-plus.yaml";
  };
}
