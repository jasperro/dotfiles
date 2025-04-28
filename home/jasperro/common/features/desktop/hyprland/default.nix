{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../common

    ./keybinds.nix

    ./waybar.nix
    # ./eww

    ../common/wayland-wm
    ../common/wayland-wm/kitty.nix
    ../common/wayland-wm/mako.nix
    ../common/wayland-wm/wofi.nix
  ];

  home.packages = with pkgs; [
    grimblast
    hyprsunset
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = with pkgs; [
      hyprlandPlugins.hyprexpo
    ];

    settings = {
      env = [
        "XCURSOR_THEME, ${config.home.pointerCursor.name}"
        "XCURSOR_SIZE, ${toString config.home.pointerCursor.size}"
      ];
      exec-once = [
        "hyprctl setcursor ${config.home.pointerCursor.name} ${toString config.home.pointerCursor.size}"
      ];
      general = {
        gaps_in = 15;
        gaps_out = 20;
        border_size = 3;
        "col.active_border" = "0xff${config.colorscheme.palette.base0C}";
        "col.inactive_border" = "0xff${config.colorscheme.palette.base02}";
      };
      group = {
        "col.border_active" = "0xff${config.colorscheme.palette.base0B}";
        "col.border_inactive" = "0xff${config.colorscheme.palette.base04}";
      };
      input = {
        kb_layout = "us";
        touchpad.disable_while_typing = false;
        # do not focus window when moving cursor
        follow_mouse = 0;
      };
      dwindle.split_width_multiplier = 1.35;

      # Freesync
      misc.vfr = "on";

      decoration = {
        inactive_opacity = 0.84;
        fullscreen_opacity = 1.0;
        rounding = 5;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
        };
        shadow = {
          enabled = true;
          range = 12;
          offset = "3 3";
          color = "0x44000000";
          color_inactive = "0x66000000";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easein,0.11, 0, 0.5, 0"
          "easeout,0.5, 1, 0.89, 1"
          "easeinback,0.36, 0, 0.66, -0.56"
          "easeoutback,0.34, 1.56, 0.64, 1"
        ];

        animation = [
          "windowsIn,1,3,easeoutback,slide"
          "windowsOut,1,3,easeinback,slide"
          "windowsMove,1,3,easeoutback"
          "workspaces,1,2,easeoutback,slide"
          "fadeIn,1,3,easeout"
          "fadeOut,1,3,easein"
          "fadeSwitch,1,3,easeout"
          "fadeShadow,1,3,easeout"
          "fadeDim,1,3,easeout"
          "border,1,3,easeout"
        ];
      };

      bind =
        let
          playerctl = "${config.services.playerctld.package}/bin/playerctl";
          playerctld = "${config.services.playerctld.package}/bin/playerctld";
          makoctl = "${config.services.mako.package}/bin/makoctl";
          wofi = "${config.programs.wofi.package}/bin/wofi";
          hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";

          grimblast = "${pkgs.grimblast}/bin/grimblast";
          pactl = "${pkgs.pulseaudio}/bin/pactl";

          gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
          xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
          defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";

          terminal = config.home.sessionVariables.TERMINAL;
          browser = defaultApp "x-scheme-handler/https";
        in
        [
          # Program bindings
          "SUPER,Return,exec,${terminal}"
          "SUPER,b,exec,${browser}"
          # Brightness control (only works if the system has lightd)
          ",XF86MonBrightnessUp,exec,light -A 10"
          ",XF86MonBrightnessDown,exec,light -U 10"
          # Volume
          ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
          ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
          "SHIFT,XF86AudioMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
          ",XF86AudioMicMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
          # Screenshotting
          ",Print,exec,${grimblast} --notify copy output"
          "SHIFT,Print,exec,${grimblast} --notify copy active"
          "CONTROL,Print,exec,${grimblast} --notify copy screen"
          "SUPER,Print,exec,${grimblast} --notify copy window"
          "ALT,Print,exec,${grimblast} --notify copy area"
        ]
        ++
          # Media control
          (lib.optionals config.services.playerctld.enable [
            ",XF86AudioNext,exec,${playerctl} next"
            ",XF86AudioPrev,exec,${playerctl} previous"
            ",XF86AudioPlay,exec,${playerctl} play-pause"
            ",XF86AudioStop,exec,${playerctl} stop"
            "ALT,XF86AudioNext,exec,${playerctld} shift"
            "ALT,XF86AudioPrev,exec,${playerctld} unshift"
            "ALT,XF86AudioPlay,exec,systemctl --user restart playerctld"
          ])
        ++
          # Screen lock
          (lib.optionals config.programs.hyprlock.enable [
            "SUPER,backspace,exec,${hyprlock} -S"
          ])
        ++
          # Notification manager
          (lib.optionals config.services.mako.enable [
            "SUPER,w,exec,${makoctl} dismiss"
          ])
        ++
          # Launcher
          (lib.optionals config.programs.wofi.enable [
            "SUPER,x,exec,${wofi} -S drun"
            "SUPER,d,exec,${wofi} -S run"
          ]);

      monitor = map (
        m:
        let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString m.x}x${toString m.y}";
        in
        "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
      ) (config.monitors);

      workspace = map (m: "${m.name},${m.workspace}") (
        lib.filter (m: m.enabled && m.workspace != null) config.monitors
      );

    };
    # This is order sensitive, so it has to come here.
    extraConfig = ''
      # Passthrough mode (e.g. for VNC)
      bind=SUPER,P,submap,passthrough
      submap=passthrough
      bind=SUPER,P,submap,reset
      submap=reset
    '';
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
    };
  };

  services.hyprpolkitagent.enable = true;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
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

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "Password...";
          shadow_passes = 2;
        }
      ];
    };
  };
}
