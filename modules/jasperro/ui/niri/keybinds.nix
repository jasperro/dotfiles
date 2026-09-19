{
  inputs,
  jdfPath,
  lib,
  ...
}:
let
  # Map keys to directions
  directionL = rec {
    Left = "left";
    h = Left;
  };
  directionR = rec {
    Right = "right";
    l = Right;
  };
  directionD = rec {
    Down = "down";
    j = Down;
  };
  directionU = rec {
    Up = "up";
    k = Up;
  };
  directionsX = directionL // directionR;
  directionsY = directionU // directionD;
in
{
  jdf = lib.setAttrByPath jdfPath {
    homeManager =
      { config, pkgs, ... }:
      {
        wayland.windowManager.niri.settings = {
          binds =
            let
              noctalia = cmd: {
                spawn = [
                  "noctalia"
                  "msg"
                ]
                ++ (pkgs.lib.splitString " " cmd);
              };
              playerctl = lib.getExe config.services.playerctld.package;
              playerctld = lib.getExe config.services.playerctld.package;
              makoctl = lib.getExe config.services.mako.package;
              wofi = lib.getExe config.programs.wofi.package;
              hyprlock = lib.getExe config.programs.hyprlock.package;
              cliphist = lib.getExe config.services.cliphist.package;
              flameshot = lib.getExe config.services.flameshot.package;

              grimblast = lib.getExe pkgs.grimblast;
              pactl = "${pkgs.pulseaudio}/bin/pactl";

              gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
              xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
              defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

              terminal = config.home.sessionVariables.TERMINAL;
              browser = defaultApp "x-scheme-handler/https";
            in
            lib.attrsets.mergeAttrsList [
              # Core window management & session keybinds
              {
                "Super+Shift+S".spawn = [
                  "systemctl"
                  "suspend"
                ];
                "Super+Shift+P".spawn = [
                  "loginctl"
                  "lock-session"
                ];

                "Super+D".toggle-overview = [ ];
                "Super+Tab".toggle-overview = [ ];

                "Super+Q".close-window = [ ];

                "Super+Comma".consume-window-into-column = [ ];
                "Super+Period".expel-window-from-column = [ ];
                "Super+Slash".switch-preset-column-width = [ ];

                "Super+M".maximize-window-to-edges = [ ];
                "Super+F".maximize-column = [ ];
                "Super+Shift+F".fullscreen-window = [ ];

                "Super+Shift+Space".switch-focus-between-floating-and-tiling = [ ];
                "Super+Space".toggle-window-floating = [ ];

                "Super+Minus".set-column-width = "-10%";
                "Super+Shift+Minus".set-window-height = "-10%";

                "Super+Equal".set-column-width = "+10%";
                "Super+Shift+Equal".set-window-height = "+10%";

                "Super+Control+WheelScrollDown" = {
                  focus-workspace-down = [ ];
                  _props.cooldown-ms = 150;
                };
                "Super+Control+WheelScrollUp" = {
                  focus-workspace-up = [ ];
                  _props.cooldown-ms = 150;
                };
                "Super+WheelScrollUp".focus-column-left = [ ];
                "Super+WheelScrollDown".focus-column-right = [ ];
              }
              (lib.concatMapAttrs (key: direction: {
                "Super+${key}"."focus-workspace-${direction}" = [ ];
                "Super+Shift+${key}" = {
                  "move-column-to-workspace-${direction}" = {
                    _props.focus = false;
                  };
                };
              }) directionsY)
              (lib.concatMapAttrs (key: direction: {
                "Super+${key}"."focus-column-${direction}" = [ ];
                "Super+Shift+${key}"."move-column-${direction}" = [ ];
              }) directionsX)

              # Program launching & audio
              {
                "Super+Return".spawn-sh = "${terminal}";
                "Super+Shift+F23".spawn-sh = "${terminal}";
                "Super+B".spawn-sh = "${browser}";

                "XF86AudioRaiseVolume".spawn = [
                  pactl
                  "set-sink-volume"
                  "@DEFAULT_SINK@"
                  "+5%"
                ];
                "XF86AudioLowerVolume".spawn = [
                  pactl
                  "set-sink-volume"
                  "@DEFAULT_SINK@"
                  "-5%"
                ];
                "XF86AudioMute".spawn = [
                  pactl
                  "set-sink-mute"
                  "@DEFAULT_SINK@"
                  "toggle"
                ];

                "Print".spawn = [
                  grimblast
                  "--notify"
                  "copy"
                  "output"
                ];
                "Shift+Print".spawn = [
                  grimblast
                  "--notify"
                  "copy"
                  "active"
                ];
                "Control+Print".spawn = [
                  grimblast
                  "--notify"
                  "copy"
                  "screen"
                ];
                "Super+Print".spawn = [
                  grimblast
                  "--notify"
                  "copy"
                  "window"
                ];
                "Alt+Print".spawn = [
                  grimblast
                  "--notify"
                  "copy"
                  "area"
                ];
              }

              # Media control
              (lib.optionals config.services.playerctld.enable [
                {
                  "XF86AudioNext".spawn = [
                    playerctl
                    "next"
                  ];
                  "XF86AudioPrev".spawn = [
                    playerctl
                    "previous"
                  ];
                  "XF86AudioPlay".spawn = [
                    playerctl
                    "play-pause"
                  ];
                  "XF86AudioStop".spawn = [
                    playerctl
                    "stop"
                  ];
                  "Alt+XF86AudioNext".spawn = [
                    playerctld
                    "shift"
                  ];
                  "Alt+XF86AudioPrev".spawn = [
                    playerctld
                    "unshift"
                  ];
                  "Alt+XF86AudioPlay".spawn = [
                    "systemctl"
                    "--user"
                    "restart"
                    "playerctld"
                  ];
                }
              ])

              # Screen lock
              (
                if config.programs.hyprlock.enable then
                  [
                    {
                      "Super+Shift+M".spawn = hyprlock;
                    }
                  ]
                else if config.programs.noctalia.enable then
                  [
                    {
                      "Super+Shift+M" = noctalia "session lock";
                    }
                  ]
                else
                  [ ]
              )

              # Notification manager
              (lib.optionals config.services.mako.enable [
                {
                  "Super+W".spawn = [
                    makoctl
                    "dismiss"
                  ];
                }
              ])

              # Flameshot screenshot override
              (lib.optionals config.services.flameshot.enable [
                {
                  "Super+Print".spawn = [
                    flameshot
                    "launcher"
                  ];
                  "Control+Print".spawn = [
                    flameshot
                    "gui"
                  ];
                }
              ])

              # Wofi app launcher
              (lib.optionals config.programs.wofi.enable [
                {
                  "Super+C".spawn = [
                    wofi
                    "-S"
                    "drun"
                  ];
                  "Super+X".spawn = [
                    wofi
                    "-S"
                    "run"
                  ];
                  "Super+V".spawn-sh = "${cliphist} list | ${wofi} --dmenu | ${cliphist} decode | wl-copy";
                  "Super+Shift+E".spawn = [
                    "${inputs.wofi-power-menu.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/wofi-power-menu"
                    "--disable"
                    "hibernate"
                  ];
                }
              ])

              # Noctalia panel/launcher overrides
              (lib.optionals config.programs.noctalia.enable [
                {
                  "Super+Z" = noctalia "panel-toggle launcher /win";
                  "Super+X" = noctalia "panel-toggle launcher";
                  "Super+V" = noctalia "panel-toggle clipboard";
                  "Super+Shift+E" = noctalia "panel-toggle session";
                }
              ])
            ];
        };
      };
  };
}
