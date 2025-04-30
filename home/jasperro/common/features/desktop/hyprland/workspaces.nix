{ lib, ... }:
let
  workspaceKeys =
    (map toString (lib.range 1 9)) ++ [ "0" ] ++ (map (n: "F${toString n}") (lib.range 1 12));
in
{
  wayland.windowManager.hyprland.settings = {
    workspace = [
      "0,defaultName:10"
    ] ++ (map (n: "${toString (n + 10)},defaultName:f${toString n}") (lib.range 1 12));
    bind =
      # Change workspace to number
      (lib.imap1 (i: n: "SUPER,${n},workspace,${toString i}") workspaceKeys)
      ++
        # Move window to workspace
        (lib.imap1 (i: n: "SUPERSHIFT,${n},movetoworkspacesilent,${toString i}") workspaceKeys);
  };
}
