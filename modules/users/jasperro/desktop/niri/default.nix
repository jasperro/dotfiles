{
  inputs,
  lib,
  __findFile,
  ...
}:
{
  JDF.users._.jasperro._.desktop._.niri = {
    includes = [
      <JDF/desktop/niri>
      <JDF/users/jasperro/desktop/niri/workspaces>
      <JDF/users/jasperro/desktop/niri/keybinds>
      <JDF/users/jasperro/desktop/niri/unofficial>
      <JDF/users/jasperro/desktop/niri/noctalia-shell>

      <JDF/users/jasperro/desktop/wayland-wm>

      <JDF/users/jasperro/desktop/programs/cliphist>
      <JDF/users/jasperro/desktop/programs/kitty>
      <JDF/users/jasperro/desktop/programs/stylix>
    ];
    homeManager =
      {
        config,
        pkgs,
        ...
      }:
      {
        key = "jasperro-niri";
        imports = [
          inputs.niri-nix.homeModules.default
        ];

        home.packages = with pkgs; [
          inputs.niri-nix.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
          grimblast
          hyprsunset
          inputs.wofi-power-menu.packages.${pkgs.stdenv.hostPlatform.system}.default
          inputs.noctalia.packages.${stdenv.hostPlatform.system}.default
          waypaper
          swaybg
        ];

        xdg.portal = {
          extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
          ];
          config = {
            niri = {
              "org.freedesktop.impl.portal.FileChooser" = "kde";
            };
          };
        };

        wayland.windowManager.niri.enable = true;
        wayland.windowManager.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        wayland.windowManager.niri.settings = {
          spawn-at-startup = [
            [
              "waypaper"
              "--restore"
              "--random"
            ]
          ];

          input.keyboard.xkb = {
            layout = "us";
            variant = "altgr-intl";
            options = "terminate:ctrl_alt_bksp";
          };
          input.mouse.accel-speed = 1.0;

          xwayland-satellite.path = "${lib.getExe
            inputs.niri-nix.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
          }";

          prefer-no-csd = true;

          cursor = {
            xcursor-theme = config.stylix.cursor.name;
            xcursor-size = config.stylix.cursor.size;
          };

          output = [
            {
              _args = [ "DP-2" ];
              mode = "2560x1440@180.001";
              variable-refresh-rate._props = {
                on-demand = true;
              };
              focus-at-startup = [ ];
            }
          ];

          window-rule = [
            {
              geometry-corner-radius = 8.0;
              clip-to-geometry = true;
            }
          ];

          layer-rule = [
            {
              _children = [
                {
                  match._props = {
                    namespace = "^bar*";
                    at-startup = true;
                  };
                }
              ];
              place-within-backdrop = true;
            }
          ];

          layout = {
            gaps = 10;
            always-center-single-column = true;

            empty-workspace-above-first = true;

            focus-ring.off = [ ];

            border = with config.lib.stylix.colors.withHashtag; {
              on = [ ];
              width = 4;
              active-gradient._props = {
                from = base0D;
                to = base0B;
                angle = 45;
              };
              inactive-gradient._props = {
                from = base01;
                to = base02;
                angle = 45;
                relative-to = "workspace-view";
              };
              urgent-gradient._props = {
                from = base08;
                to = base09;
                angle = 45;
              };
            };

            preset-column-widths._children = [
              { proportion = 1. / 3.; }
              { proportion = 1. / 2.; }
              { proportion = 2. / 3.; }
            ];
          };

          clipboard.disable-primary = true;

          overview = {
            zoom = 0.5;
            backdrop-color = config.lib.stylix.colors.withHashtag.base01;
          };

          screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";

          binds =
            let
              noctalia = cmd: {
                spawn = [
                  "noctalia-shell"
                  "ipc"
                  "call"
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
            lib.attrsets.mergeAttrsList (
              [
                {
                  # Program bindings
                  "Super+Return".spawn-sh = "${terminal}";
                  "Super+B".spawn-sh = "${browser}";
                  # Volume
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
                  # Screenshotting
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
              ]
              ++
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
              ++
                # Screen lock

                (
                  if config.programs.hyprlock.enable then
                    [
                      {
                        "Super+Shift+M".spawn = hyprlock;
                      }
                    ]
                  else if config.programs.noctalia-shell.enable then
                    [
                      {
                        "Super+Shift+M" = noctalia "lockScreen lock";
                      }
                    ]
                  else
                    [ ]
                )
              ++
                # Notification manager
                (lib.optionals config.services.mako.enable [
                  {
                    "Super+W".spawn = [
                      makoctl
                      "dismiss"
                    ];
                  }
                ])
              ++
                # Screenshots
                (lib.optionals config.services.flameshot.enable [
                  {
                    # Full screen or window
                    "Super+Print".spawn = [
                      flameshot
                      "launcher"
                    ];
                    # Selection, draw mode
                    "Control+Print".spawn = [
                      flameshot
                      "gui"
                    ];
                  }
                ])
              ++
                # Launcher
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
              ++
                # Launcher
                (lib.optionals config.programs.noctalia-shell.enable [
                  {
                    "Super+Z" = noctalia "launcher windows";
                    "Super+X" = noctalia "launcher toggle";
                    "Super+C" = noctalia "launcher command";
                    "Super+V" = noctalia "launcher clipboard";
                    "Super+Shift+E" = noctalia "sessionMenu toggle";
                  }
                ])
            );
        };

        services.hypridle =
          let
            noctalia = "${
              lib.getExe inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
            } ipc call";
          in
          {
            enable = config.programs.hyprlock.enable || config.programs.noctalia-shell.enable;
            settings = {
              general =
                if config.programs.hyprlock.enable then
                  {
                    before_sleep_cmd = "hyprlock --immediate";
                    after_sleep_cmd = "hyprctl dispatch dpms on";
                    ignore_dbus_inhibit = false;
                    lock_cmd = "hyprlock --immediate";
                  }
                else
                  {
                    before_sleep_cmd = "${noctalia} lockScreen lock";
                    after_sleep_cmd = "niri msg action power-on-monitors";
                    ignore_dbus_inhibit = false;
                    lock_cmd = "${noctalia} lockScreen lock";
                  };

              listener =
                if config.programs.hyprlock.enable then
                  [
                    {
                      timeout = 900;
                      on-timeout = "hyprlock";
                    }
                    {
                      timeout = 1200;
                      on-timeout = "hyprctl dispatch dpms off";
                      on-resume = "hyprctl dispatch dpms on";
                    }
                  ]
                else
                  [
                    {
                      timeout = 900;
                      on-timeout = "${noctalia} lockScreen lock";
                    }
                    {
                      timeout = 1200;
                      on-timeout = "niri msg action power-off-monitors";
                      on-resume = "niri msg action power-on-monitors";
                    }
                  ];
            };
          };

        programs.hyprlock = {
          enable = false;
          settings = {
            general = {
              disable_loading_bar = true;
              grace = 15;
              hide_cursor = true;
              no_fade_in = false;
            };

            background = [
              {
                path = "screenshot";
                blur_passes = 3;
                blur_size = 8;
              }
            ];

            input-field = with config.lib.stylix.colors; [
              {
                size = "200, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "rgb(${base0F})";
                inner_color = "rgb(${base00})";
                outer_color = "rgb(${base0C})";
                outline_thickness = 5;
                placeholder_text = "Password...";
                shadow_passes = 2;
              }
            ];
          };
        };
      };
  };
}
