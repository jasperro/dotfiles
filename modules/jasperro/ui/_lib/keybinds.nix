{ lib }:
rec {
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

  mkBinds =
    {
      config,
      pkgs,
      inputs,
      modKey ? "Mod",
      mkSpawn,
      mkSpawnSh,
      mkWmAction,
      mkNoctalia,
      mkWheel,
      mkWithOptions ? (action: opts: action),
    }:
    let
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

      wofiPowerMenu = "${
        inputs.wofi-power-menu.packages.${pkgs.stdenv.hostPlatform.system}.default
      }/bin/wofi-power-menu";
    in
    lib.attrsets.mergeAttrsList [
      # Core window management & session keybinds
      {
        "${modKey}+Shift+S" = mkSpawn [
          "systemctl"
          "suspend"
        ];
        "${modKey}+Shift+P" = mkSpawn [
          "loginctl"
          "lock-session"
        ];

        "${modKey}+D" = mkWmAction "overview-toggle";
        "${modKey}+Tab" = mkWmAction "overview-toggle";

        "${modKey}+Q" = mkWmAction "window-close";

        "${modKey}+Comma" = mkWmAction "window-consume-left";
        "${modKey}+Period" = mkWmAction "window-consume-right";
        "${modKey}+Slash" = mkWmAction "window-cycle-primary-extent";

        "${modKey}+M" = mkWmAction "window-toggle-maximize-to-edges";
        "${modKey}+F" = mkWmAction "window-toggle-maximize";
        "${modKey}+Shift+F" = mkWmAction "window-toggle-fullscreen";

        "${modKey}+Shift+Space" = mkWmAction "window-focus-switch-floating";
        "${modKey}+Space" = mkWmAction "window-toggle-floating";

        "${modKey}+Minus" = mkWmAction "window-resize-width-dec";
        "${modKey}+Shift+Minus" = mkWmAction "window-resize-height-dec";

        "${modKey}+Equal" = mkWmAction "window-resize-width-inc";
        "${modKey}+Shift+Equal" = mkWmAction "window-resize-height-inc";

        # Scroll / Workspace strip actions
        "${mkWheel modKey "Up"}" = mkWmAction "window-focus-previous";
        "${mkWheel modKey "Down"}" = mkWmAction "window-focus-next";

        "${mkWheel "${modKey}+Control" "Up"}" = mkWithOptions (mkWmAction "workspace-previous") {
          cooldown_ms = 150;
        };
        "${mkWheel "${modKey}+Control" "Down"}" = mkWithOptions (mkWmAction "workspace-next") {
          cooldown_ms = 150;
        };

        "${mkWheel "${modKey}+Shift" "Up"}" = mkWithOptions (mkWmAction "window-consume-or-expel-right") {
          cooldown_ms = 100;
        };
        "${mkWheel "${modKey}+Shift" "Down"}" = mkWithOptions (mkWmAction "window-consume-or-expel-left") {
          cooldown_ms = 100;
        };
      }

      # Directional Y bindings (Vertical: Focus / Move / Workspaces)
      (lib.concatMapAttrs (key: direction: {
        "${modKey}+${key}" = mkWmAction "focus-y-${direction}";
        "${modKey}+Shift+${key}" = mkWmAction "move-y-${direction}";
        "${modKey}+Control+${key}" = mkWmAction (
          if direction == "down" then "workspace-next" else "workspace-previous"
        );
        "${modKey}+Control+Shift+${key}" = mkWmAction (
          if direction == "down" then "column-move-to-workspace-next" else "column-move-to-workspace-previous"
        );
      }) directionsY)

      # Directional X bindings (Horizontal: Focus / Move / Output)
      (lib.concatMapAttrs (key: direction: {
        "${modKey}+${key}" = mkWmAction "focus-x-${direction}";
        "${modKey}+Shift+${key}" = mkWmAction "move-x-${direction}";
        "${modKey}+Control+${key}" = mkWmAction (
          if direction == "right" then "output-focus-next" else "output-focus-previous"
        );
        "${modKey}+Control+Shift+${key}" = mkWmAction "column-move-to-output-${direction}";
      }) directionsX)

      # Programs & Audio
      {
        "${modKey}+Return" = mkSpawnSh terminal;
        "${modKey}+Shift+F23" = mkSpawnSh terminal;
        "${modKey}+B" = mkSpawnSh browser;

        "XF86AudioRaiseVolume" = mkSpawn [
          pactl
          "set-sink-volume"
          "@DEFAULT_SINK@"
          "+5%"
        ];
        "XF86AudioLowerVolume" = mkSpawn [
          pactl
          "set-sink-volume"
          "@DEFAULT_SINK@"
          "-5%"
        ];
        "XF86AudioMute" = mkSpawn [
          pactl
          "set-sink-mute"
          "@DEFAULT_SINK@"
          "toggle"
        ];

        "Print" = mkSpawn [
          grimblast
          "--notify"
          "copy"
          "output"
        ];
        "Shift+Print" = mkSpawn [
          grimblast
          "--notify"
          "copy"
          "active"
        ];
        "Control+Print" = mkSpawn [
          grimblast
          "--notify"
          "copy"
          "screen"
        ];
        "${modKey}+Print" = mkSpawn [
          grimblast
          "--notify"
          "copy"
          "window"
        ];
        "Alt+Print" = mkSpawn [
          grimblast
          "--notify"
          "copy"
          "area"
        ];
      }

      # Media controls
      (lib.optionalAttrs config.services.playerctld.enable {
        "XF86AudioNext" = mkSpawn [
          playerctl
          "next"
        ];
        "XF86AudioPrev" = mkSpawn [
          playerctl
          "previous"
        ];
        "XF86AudioPlay" = mkSpawn [
          playerctl
          "play-pause"
        ];
        "XF86AudioStop" = mkSpawn [
          playerctl
          "stop"
        ];
        "Alt+XF86AudioNext" = mkSpawn [
          playerctld
          "shift"
        ];
        "Alt+XF86AudioPrev" = mkSpawn [
          playerctld
          "unshift"
        ];
        "Alt+XF86AudioPlay" = mkSpawn [
          "systemctl"
          "--user"
          "restart"
          "playerctld"
        ];
      })

      # Screen lock
      (
        if config.programs.hyprlock.enable then
          {
            "${modKey}+Shift+M" = mkSpawn [ hyprlock ];
          }
        else if config.programs.noctalia.enable then
          {
            "${modKey}+Shift+M" = mkNoctalia "session lock";
          }
        else
          { }
      )

      # Notifications
      (lib.optionalAttrs config.services.mako.enable {
        "${modKey}+W" = mkSpawn [
          makoctl
          "dismiss"
        ];
      })

      # Flameshot
      (lib.optionalAttrs config.services.flameshot.enable {
        "${modKey}+Print" = mkSpawn [
          flameshot
          "launcher"
        ];
        "Control+Print" = mkSpawn [
          flameshot
          "gui"
        ];
      })

      # Wofi
      (lib.optionalAttrs config.programs.wofi.enable {
        "${modKey}+C" = mkSpawn [
          wofi
          "-S"
          "drun"
        ];
        "${modKey}+X" = mkSpawn [
          wofi
          "-S"
          "run"
        ];
        "${modKey}+V" = mkSpawnSh "${cliphist} list | ${wofi} --dmenu | ${cliphist} decode | wl-copy";
        "${modKey}+Shift+E" = mkSpawn [
          wofiPowerMenu
          "--disable"
          "hibernate"
        ];
      })

      # Noctalia
      (lib.optionalAttrs config.programs.noctalia.enable {
        "${modKey}" = mkNoctalia "panel-toggle launcher";
        "${modKey}+Z" = mkNoctalia "panel-toggle launcher /win";
        "${modKey}+X" = mkNoctalia "panel-toggle launcher";
        "${modKey}+V" = mkNoctalia "panel-toggle clipboard";
        "${modKey}+Shift+E" = mkNoctalia "panel-toggle session";
      })
    ];
}
