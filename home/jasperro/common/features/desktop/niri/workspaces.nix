{ lib, ... }:
let
  workspaceKeys = (lib.range 1 9);
in
{
  programs.niri.settings = {
    binds = lib.mergeAttrsList (
      map (key: {
        "Super+${toString key}".action."focus-workspace" = key;
        "Super+Shift+${toString key}".action."move-column-to-workspace" = [
          { focus = false; }
          key
        ];
      }) workspaceKeys
    );
  };
}
