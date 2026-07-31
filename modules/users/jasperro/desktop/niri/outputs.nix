{ lib, ... }:
{
  jdf.users._.jasperro._.desktop._.niri._.outputs =
    let
      formatNiriOutput = monitor: {
        _args = [ monitor.name ];
        mode = "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}";
        scale = monitor.scale;

        variable-refresh-rate = lib.mkIf monitor.vrr {
          _props = {
            on-demand = true;
          };
        };

        focus-at-startup = lib.mkIf monitor.primary [ ];
      };
    in
    {
      user ? { },
      home ? { },
      host ? { },
      ...
    }:
    let
      userMonitors = user.monitors or [ ];
      homeMonitors = home.monitors or [ ];
      hostMonitors = host.monitors or [ ];

      monitors =
        if userMonitors != [ ] then
          userMonitors
        else if homeMonitors != [ ] then
          homeMonitors
        else if hostMonitors != [ ] then
          hostMonitors
        else
          [ ];
    in
    {
      homeManager = {
        wayland.windowManager.niri.settings.output = map formatNiriOutput (
          lib.filter (m: m.enabled) monitors
        );
      };
    };
}
