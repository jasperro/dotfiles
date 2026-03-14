{ pkgs, config, ... }:
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
    wayvr
    android-tools
  ];

  xdg.configFile."openxr/1/active_runtime.json".source =
    "${pkgs.wivrn}/share/openxr/1/openxr_wivrn.json";

  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
    {
      "config" :
      [
        "${config.xdg.dataHome}/Steam/config"
      ],
      "external_drivers" : null,
      "jsonid" : "vrpathreg",
      "log" :
      [
        "${config.xdg.dataHome}/Steam/logs"
      ],
      "runtime" :
      [
        "${pkgs.opencomposite}/lib/opencomposite"
      ],
      "version" : 1
    }
  '';

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
    NIXOS_OZONE_WL = "1";
  };
}
