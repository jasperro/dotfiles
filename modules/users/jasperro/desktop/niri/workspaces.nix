{ lib, ... }:
let
  workspaceKeys = (lib.range 1 9);
in
{
  JDF.users._.jasperro._.desktop._.niri._.workspaces.homeManager = {
    wayland.windowManager.niri.settings = {
      binds = lib.mergeAttrsList (
        map (key: {
          "Super+${toString key}"."focus-workspace" = key;
          "Super+Shift+${toString key}" = {
            move-column-to-workspace = {
              _args = [ key ];
              _props.focus = false;
            };
          };
        }) workspaceKeys
      );
    };
  };
}
