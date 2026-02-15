{
  lib,
  config,
  pkgs,
  inputs,
  impurity,
  ...
}:
{
  imports = [
    ../common
    ../common/wayland-wm

    ./workspaces.nix
    ./keybinds.nix

    ./noctalia-shell.nix

    # ../common/wayland-wm/waybar.nix
    # ../common/wayland-wm/mako.nix
    # ../common/wayland-wm/wofi.nix

    ../common/wayland-wm/kitty.nix
    ../common/wayland-wm/cliphist.nix
  ];

  home.packages = with pkgs; [
    inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
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

  xdg.configFile."niri/extra.kdl".source = impurity.link ./extra.kdl;

  programs.niri.settings = {
    includes = [
      { path = "extra.kdl"; }
    ];
    spawn-at-startup = [
      {
        argv = [
          "waypaper"
          "--restore"
          "--random"
        ];
      }
    ];

    input.keyboard.xkb = {
      layout = "us";
      variant = "altgr-intl";
      options = "terminate:ctrl_alt_bksp";
    };
    input.mouse.accel-speed = 1.0;

    xwayland-satellite.path = "${lib.getExe
      inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
    }";

    prefer-no-csd = true;

    cursor = {
      theme = config.stylix.cursor.name;
      size = config.stylix.cursor.size;
    };

    outputs."DP-2" = {
      mode.width = 2560;
      mode.height = 1440;
      mode.refresh = 180.001;
      variable-refresh-rate = true;
      focus-at-startup = true;
    };

    window-rules = [
      {
        geometry-corner-radius =
          let
            r = 8.0;
          in
          {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
        clip-to-geometry = true;
      }
    ];

    layer-rules = [
      {
        matches = [
          {
            namespace = "waybar";
            at-startup = true;
          }
        ];
        place-within-backdrop = true;
      }
    ];

    layout = {
      gaps = 10;
      # struts.left = 64;
      # struts.right = 64;
      always-center-single-column = true;

      empty-workspace-above-first = true;

      # shadow = {
      #   enable = true;
      # };

      focus-ring.enable = false;

      border = with config.lib.stylix.colors.withHashtag; {
        enable = true;
        width = 4;
        active.gradient = {
          from = base0D;
          to = base0B;
          angle = 45;
        };
        inactive.gradient = {
          from = base01;
          to = base02;
          angle = 45;
          relative-to = "workspace-view";
        };
        urgent.gradient = {
          from = base08;
          to = base09;
          angle = 45;
        };
      };

      # default-column-display = "tabbed";

      tab-indicator = {
        position = "top";
        gaps-between-tabs = 10;

        # hide-when-single-tab = true;
        # place-within-column = true;

        # active.color = "red";
      };

      preset-column-widths = [
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
      with config.lib.niri.actions;
      let
        noctalia =
          cmd:
          spawn (
            [
              "noctalia-shell"
              "ipc"
              "call"
            ]
            ++ (pkgs.lib.splitString " " cmd)
          );
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
            "Super+Return".action = spawn-sh "${terminal}";
            "Super+B".action = spawn-sh "${browser}";
            # Volume
            "XF86AudioRaiseVolume".action = spawn [
              pactl
              "set-sink-volume"
              "@DEFAULT_SINK@"
              "+5%"
            ];
            "XF86AudioLowerVolume".action = spawn [
              pactl
              "set-sink-volume"
              "@DEFAULT_SINK@"
              "-5%"
            ];
            "XF86AudioMute".action = spawn [
              pactl
              "set-sink-mute"
              "@DEFAULT_SINK@"
              "toggle"
            ];
            # Screenshotting
            "Print".action = spawn [
              grimblast
              "--notify"
              "copy"
              "output"
            ];
            "Shift+Print".action = spawn [
              grimblast
              "--notify"
              "copy"
              "active"
            ];
            "Control+Print".action = spawn [
              grimblast
              "--notify"
              "copy"
              "screen"
            ];
            "Super+Print".action = spawn [
              grimblast
              "--notify"
              "copy"
              "window"
            ];
            "Alt+Print".action = spawn [
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
              "XF86AudioNext".action = spawn [
                playerctl
                "next"
              ];
              "XF86AudioPrev".action = spawn [
                playerctl
                "previous"
              ];
              "XF86AudioPlay".action = spawn [
                playerctl
                "play-pause"
              ];
              "XF86AudioStop".action = spawn [
                playerctl
                "stop"
              ];
              "Alt+XF86AudioNext".action = spawn [
                playerctld
                "shift"
              ];
              "Alt+XF86AudioPrev".action = spawn [
                playerctld
                "unshift"
              ];
              "Alt+XF86AudioPlay".action = spawn [
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
                  "Super+Shift+M".action = spawn hyprlock;
                }
              ]
            else if config.programs.noctalia-shell.enable then
              [
                {
                  "Super+Shift+M".action = noctalia "lockScreen lock";
                }
              ]
            else
              [ ]
          )
        ++
          # Notification manager
          (lib.optionals config.services.mako.enable [
            {
              "Super+W".action = spawn [
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
              "Super+Print".action = spawn [
                flameshot
                "launcher"
              ];
              # Selection, draw mode
              "Control+Print".action = spawn [
                flameshot
                "gui"
              ];
            }
          ])
        ++
          # Launcher
          (lib.optionals config.programs.wofi.enable [
            {
              "Super+x".action = spawn [
                wofi
                "-S"
                "drun"
              ];
              "Super+D".action = spawn [
                wofi
                "-S"
                "run"
              ];
              "Super+V".action = spawn-sh "${cliphist} list | ${wofi} --dmenu | ${cliphist} decode | wl-copy";
              "Super+Shift+E".action = spawn [
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
              "Super+x".action = noctalia "launcher command";
              "Super+D".action = noctalia "launcher toggle";
              "Super+V".action = noctalia "launcher clipboard";
              "Super+Shift+E".action = noctalia "sessionMenu toggle";
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
}
