{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../common

    ./workspaces.nix
    ./keybinds.nix

    ../common/wayland-wm/waybar.nix

    ../common/wayland-wm
    ../common/wayland-wm/kitty.nix
    ../common/wayland-wm/mako.nix
    ../common/wayland-wm/wofi.nix
    ../common/wayland-wm/cliphist.nix
  ];

  home.packages = with pkgs; [
    inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
    grimblast
    hyprsunset
    inputs.wofi-power-menu.packages.${pkgs.stdenv.hostPlatform.system}.default
    waypaper
    inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper
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

  programs.niri.settings = {
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

    outputs."DP-2" = {
      mode.width = 2560;
      mode.height = 1440;
      mode.refresh = 180.001;
      variable-refresh-rate = true;
      focus-at-startup = true;
      backdrop-color = "#001100";
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
    };

    clipboard.disable-primary = true;

    overview.zoom = 0.5;

    screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";

    binds =
      with config.lib.niri.actions;
      let
        sh = spawn "sh" "-c";
        playerctl = "${config.services.playerctld.package}/bin/playerctl";
        playerctld = "${config.services.playerctld.package}/bin/playerctld";
        makoctl = "${config.services.mako.package}/bin/makoctl";
        wofi = "${config.programs.wofi.package}/bin/wofi";
        hyprlock = "${config.programs.hyprlock.package}/bin/hyprlock";
        cliphist = "${config.services.cliphist.package}/bin/cliphist";
        flameshot = "${config.services.flameshot.package}/bin/flameshot";

        grimblast = "${pkgs.grimblast}/bin/grimblast";
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
            "Super+Return".action = sh "${terminal}";
            "Super+B".action = sh "${browser}";
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
          (lib.optionals config.programs.hyprlock.enable [
            {
              "Super+Backspace".action = spawn hyprlock;
            }
          ])
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
              "Super+V".action = sh "${cliphist} list | ${wofi} --dmenu | ${cliphist} decode | wl-copy";
              "Super+Shift+E".action = spawn [
                "${inputs.wofi-power-menu.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/wofi-power-menu"
                "--disable"
                "hibernate"
              ];
            }
          ])
      );
  };
  programs.hyprlock = {
    enable = true;
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
