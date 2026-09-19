{
  inputs,
  jdfPath,
  lib,
  ...
}:
let
  directionL = {
    Left = "left";
    h = "left";
  };
  directionR = {
    Right = "right";
    l = "right";
  };
  directionD = {
    Down = "down";
    j = "down";
  };
  directionU = {
    Up = "up";
    k = "up";
  };

  directionsX = directionL // directionR;
  directionsY = directionU // directionD;
in
{
  jdf = lib.setAttrByPath jdfPath {
    homeManager =
      {
        config,
        pkgs,
        ...
      }:
      {
        programs.umbriel.settings.hot_corners.top_left = {
          enabled = true;
          delay_ms = 200;
          action = "overview-open";
        };
        programs.umbriel.settings.keybinds =
          let
            noctalia = cmd: "spawn:noctalia msg ${cmd}";
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
            {
              # Session & Core Window management
              "Mod+Shift+S" = "spawn:systemctl suspend";
              "Mod+Shift+P" = "spawn:loginctl lock-session";

              "Mod+D" = "overview-toggle";
              "Mod+Tab" = "overview-toggle";

              "Mod+Q" = "window-close";

              "Mod+Comma" = "window-consume-left";
              "Mod+Period" = "window-consume-or-expel-right";
              "Mod+Slash" = "window-cycle-primary-extent";

              "Mod+M" = "window-toggle-maximize-to-edges";
              "Mod+F" = "window-toggle-maximize";
              "Mod+Shift+F" = "window-toggle-fullscreen";

              "Mod+Shift+Space" = "window-focus-switch-floating";
              "Mod+Space" = "window-toggle-floating";

              "Mod+Minus" = "window-modify-width-right:-0.1";
              "Mod+Shift+Minus" = "window-modify-height-down:-0.1";

              "Mod+Equal" = "window-modify-width-right:+0.1";
              "Mod+Shift+Equal" = "window-modify-height-down:+0.1";

              # Scroll / Workspace strip actions
              "Mod+WheelUp" = "window-focus-next";
              "Mod+WheelDown" = "window-focus-previous";

              "Mod+Control+WheelUp" = {
                action = "workspace-previous";
                cooldown_ms = 150;
              };
              "Mod+Control+WheelDown" = {
                action = "workspace-next";
                cooldown_ms = 150;
              };
              "Mod+Shift+WheelUp" = {
                action = "window-consume-or-expel-right";
                cooldown_ms = 100;
              };
              "Mod+Shift+WheelDown" = {
                action = "window-consume-or-expel-left";
                cooldown_ms = 100;
              };

              # Programs & Audio
              "Mod+Return" = "spawn:${terminal}";
              "Mod+Shift+F23" = "spawn:${terminal}";
              "Mod+B" = "spawn:${browser}";

              "XF86AudioRaiseVolume" = "spawn:${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioLowerVolume" = "spawn:${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86AudioMute" = "spawn:${pactl} set-sink-mute @DEFAULT_SINK@ toggle";

              "Print" = "spawn:${grimblast} --notify copy output";
              "Shift+Print" = "spawn:${grimblast} --notify copy active";
              "Control+Print" = "spawn:${grimblast} --notify copy screen";
              "Mod+Print" = "spawn:${grimblast} --notify copy window";
              "Alt+Print" = "spawn:${grimblast} --notify copy area";
            }

            # Directional Y bindings (Vertical: Focus Windows / Workspaces)
            (lib.concatMapAttrs (key: direction: {
              # Focus window vertically
              "Mod+${key}" = "window-focus-${direction}";

              # Move window vertically
              "Mod+Shift+${key}" = "window-move-${direction}";

              # Switch workspaces (Navigating view)
              "Mod+Control+${key}" = if direction == "down" then "workspace-next" else "workspace-previous";

              # Move window/column to next workspace
              "Mod+Control+Shift+${key}" =
                if direction == "down" then
                  "column-move-to-workspace-next"
                else
                  "column-move-to-workspace-previous";
            }) directionsY)

            # Directional X bindings (Horizontal: Focus Columns / Consume-Expel / Outputs)
            (lib.concatMapAttrs (key: direction: {
              # Focus column horizontally
              "Mod+${key}" = "window-focus-${direction}";

              # Consume or expel window horizontally (Replaces column move for single windows)
              "Mod+Shift+${key}" = "window-consume-or-expel-${direction}";

              # Switch monitor/output focus (Navigating view)
              "Mod+Control+${key}" =
                if direction == "right" then "output-focus-next" else "output-focus-previous";

              # Move column to monitor
              "Mod+Control+Shift+${key}" = "column-move-to-output-${direction}";
            }) directionsX)

            # Media controls
            (lib.optionalAttrs config.services.playerctld.enable {
              "XF86AudioNext" = "spawn:${playerctl} next";
              "XF86AudioPrev" = "spawn:${playerctl} previous";
              "XF86AudioPlay" = "spawn:${playerctl} play-pause";
              "XF86AudioStop" = "spawn:${playerctl} stop";
              "Alt+XF86AudioNext" = "spawn:${playerctld} shift";
              "Alt+XF86AudioPrev" = "spawn:${playerctld} unshift";
              "Alt+XF86AudioPlay" = "spawn:systemctl --user restart playerctld";
            })

            # Screen lock
            (
              if config.programs.hyprlock.enable then
                {
                  "Mod+Shift+M" = "spawn:${hyprlock}";
                }
              else if config.programs.noctalia.enable then
                {
                  "Mod+Shift+M" = noctalia "session lock";
                }
              else
                { }
            )

            # Mako notifications
            (lib.optionalAttrs config.services.mako.enable {
              "Mod+W" = "spawn:${makoctl} dismiss";
            })

            # Flameshot
            (lib.optionalAttrs config.services.flameshot.enable {
              "Mod+Print" = "spawn:${flameshot} launcher";
              "Control+Print" = "spawn:${flameshot} gui";
            })

            # Wofi
            (lib.optionalAttrs config.programs.wofi.enable {
              "Mod+C" = "spawn:${wofi} -S drun";
              "Mod+X" = "spawn:${wofi} -S run";
              "Mod+V" = "spawn:sh -c '${cliphist} list | ${wofi} --dmenu | ${cliphist} decode | wl-copy'";
              "Mod+Shift+E" = "spawn:${
                inputs.wofi-power-menu.packages.${pkgs.stdenv.hostPlatform.system}.default
              }/bin/wofi-power-menu --disable hibernate";
            })

            # Noctalia integrations
            (lib.optionalAttrs config.programs.noctalia.enable {
              "Mod" = noctalia "panel-toggle launcher";
              "Mod+Z" = noctalia "panel-toggle launcher /win";
              "Mod+X" = noctalia "panel-toggle launcher";
              "Mod+V" = noctalia "panel-toggle clipboard";
              "Mod+Shift+E" = noctalia "panel-toggle session";
            })
          ];
      };
  };
}
