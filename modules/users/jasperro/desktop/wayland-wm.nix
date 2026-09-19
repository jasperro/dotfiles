{
  jdfPath,
  lib,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath {
    homeManager =
      { pkgs, config, ... }:
      let
        browser = "librewolf.desktop";
      in
      {
        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "default-web-browser" = [ browser ];
            "text/html" = [ browser ];
            "x-scheme-handler/http" = [ browser ];
            "x-scheme-handler/https" = [ browser ];
            "x-scheme-handler/about" = [ browser ];
            "x-scheme-handler/unknown" = [ browser ];
          };
        };
        home.packages = with pkgs; [
          # General tools for wayland desktops
          grim
          imv
          mimeo
          slurp
          waypipe
          wf-recorder
          wl-clipboard
          wl-mirror
          ydotool
          wayvr
          android-tools
        ];

        home.sessionVariables = {
          MOZ_ENABLE_WAYLAND = 1;
          QT_QPA_PLATFORM = "wayland";
          LIBSEAT_BACKEND = "logind";
          NIXOS_OZONE_WL = "1";
        };
      };
  };
}
