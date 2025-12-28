{ pkgs, ... }:
let
  browser = "librewolf.desktop";
in
{
  imports = [
    ./stylix.nix
  ];
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
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
    NIXOS_OZONE_WL = "1";
  };
}
