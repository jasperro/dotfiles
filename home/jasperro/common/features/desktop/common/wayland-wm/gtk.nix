{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in
rec {
  gtk = {
    enable = true;
    font = {
      name = config.fontProfiles.regular.family;
      size = 10;
    };
    theme = {
      name = "${config.colorscheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorscheme; };
    };
    iconTheme = {
      name = "Breeze Dark";
      package = pkgs.kdePackages.breeze-icons;
    };
  };

  home.pointerCursor = rec {
    name = "breeze";
    package = pkgs.kdePackages.breeze-icons;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    x11.defaultCursor = name;
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${home.pointerCursor.name}";
      "Net/IconThemeName" = "${home.pointerCursor.name}";
    };
  };
}
