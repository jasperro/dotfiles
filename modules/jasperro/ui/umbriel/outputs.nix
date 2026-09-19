{
  lib,
  jdfPath,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath (
    let
      formatOutput = monitor: {
        name = monitor.name;
        value = {
          mode = "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}";
          scale = monitor.scale;
          vrr = if monitor.vrr then "always" else "disabled";
        };
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
        programs.umbriel.settings.output = lib.listToAttrs (
          map formatOutput (lib.filter (m: m.enabled) monitors)
        );
      };
    }
  );
}
