# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ impurity, ... }:
{
  # You can import other home-manager modules here
  imports = [
    ../common
    ../common/features/editors/vscode
    ../common/features/desktop/common
    ../common/features/desktop/hyprland
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
    image = impurity.link ./wallpaper.jpg;
    polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/penumbra-dark-contrast-plus.yaml";
    # Currently not in nixpkgs-unstable
    base16Scheme = {
      base00 = "#181B1F"; # shade-
      base01 = "#24272B"; # shade
      base02 = "#3E4044"; # shade+
      base03 = "#636363"; # sky-
      base04 = "#9E9E9E"; # sky
      base05 = "#CECECE"; # sky+
      base06 = "#FFF7ED"; # sun
      base07 = "#FFFDFB"; # sun+
      base08 = "#DF7F78"; # red
      base09 = "#CE9042"; # orange
      base0A = "#9CA748"; # yellow
      base0B = "#50B584"; # green
      base0C = "#00B3C2"; # cyan
      base0D = "#61A3E6"; # blue
      base0E = "#A48FE1"; # purple
      base0F = "#D080B6"; # magenta
    };
  };
}
