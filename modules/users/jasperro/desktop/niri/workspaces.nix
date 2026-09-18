{ lib, jdfPath, ... }:
let
  workspaceKeys = (lib.range 1 9);
in
{
  jdf = lib.setAttrByPath jdfPath {
    homeManager = {
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
  };
}
