{ lib, config, ... }:
let
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = lib.mkIf (cfg.enable && cfg.systemdIntegration) {
    systemd.user.targets.hyprland-session-startup = {
      Unit = {
        Description = "Startup Hyprland systemd dependencies";
        StopWhenUnneeded = "true";

        Wants = [
          "swayidle.service"
          "waybar.service"
        ];
      };
      Install = {
        WantedBy = [
          "hyprland-session.target"
        ];
      };
    };

    systemd.user.targets.hyprland-session-shutdown = {
      Unit = {
        Description = "Shutdown running Hyprland session";
        DefaultDependencies = "no";
        StopWhenUnneeded = "true";

        Conflicts = [
          "graphical-session.target"
          "graphical-session-pre.target"
          "hyprland-session.target"
        ];
        After = [
          "graphical-session.target"
          "graphical-session-pre.target"
          "hyprland-session.target"
        ];
      };
    };
    wayland.windowManager.hyprland.settings.bind = lib.mkAfter [
      "SUPERSHIFT,e,exec,systemctl --user start hyprland-session-shutdown.target; hyprctl dispatch exit"
    ];
  };
}
