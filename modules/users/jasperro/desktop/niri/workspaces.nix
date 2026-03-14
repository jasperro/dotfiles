{ lib, ... }:
let
  workspaceKeys = (lib.range 1 9);
in
{
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
}
