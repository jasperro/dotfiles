{
  inputs,
  jdfPath,
  lib,
  ...
}:
{
  flake-file.inputs = {
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  jdf = lib.setAttrByPath jdfPath {
    homeManager =
      {
        pkgs,
        config,
        ...
      }:
      {
        imports = [ inputs.stylix.homeModules.stylix ];
        stylix = {
          enable = true;
          base16Scheme = lib.mkIf (config.stylix.image == null) (
            lib.mkDefault "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml"
          );
          fonts = {
            serif = {
              package = pkgs.source-serif;
              name = "Source Serif";
            };

            sansSerif = {
              package = pkgs.terminus_font_ttf;
              name = "Terminus (TTF)";
            };

            monospace = {
              package = pkgs.terminus_font_ttf;
              name = "Terminus (TTF)";
            };

            emoji = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };

            sizes = {
              terminal = 12;
              desktop = 10;
              popups = 10;
              applications = 10;
            };
          };
          autoEnable = false;
          targets = {
            gtk.enable = true;
            hyprpaper.enable = true;
            # kde.enable = true;
            qt = {
              enable = true;
              standardDialogs = "xdgdesktopportal";
            };
            nixvim.enable = true;
          };
          cursor = {
            package = pkgs.rose-pine-cursor;
            name = "BreezeX-RosePine-Linux";
            size = 36;
          };
          icons = {
            enable = true;
            package = pkgs.papirus-icon-theme;
            dark = "Papirus-Dark";
            light = "Papirus";
          };
          opacity = {
            desktop = 0.6;
            popups = 0.6;
          };
        };

        services.xsettingsd = {
          enable = true;
          settings = {
            "Net/ThemeName" = "${config.gtk.theme.name}";
            "Net/IconThemeName" = "${config.gtk.iconTheme.name}";
          };
        };
      };
  };
}
