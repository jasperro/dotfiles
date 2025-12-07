{ lib, config, ... }:
let
  workspaceKeys = (map toString (lib.range 1 9));
in
{
  programs.niri.settings = {
    binds = lib.mergeAttrsList (
      map (key: {
        "Super+${key}".action.focus-workspace = key;
        "Super+Shift+${key}".action.move-column-to-workspace = key;
      }) workspaceKeys
    );
  };
}
