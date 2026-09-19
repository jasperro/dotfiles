{
  jdfPath,
  lib,
  ...
}:
let
  workspaceKeys = lib.range 1 9;
in
{
  jdf = lib.setAttrByPath jdfPath {
    homeManager = {
      programs.umbriel.settings.keybinds = lib.mergeAttrsList (
        map (key: {
          "Mod+${toString key}" = "workspace-switch:${toString key}";
          "Mod+Shift+${toString key}" = "column-move-to-workspace:${toString key}";
        }) workspaceKeys
      );
    };
  };
}
