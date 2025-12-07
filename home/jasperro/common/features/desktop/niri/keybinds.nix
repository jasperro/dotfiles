{ lib, config, ... }:
let
  # Map keys to directions
  directionL = rec {
    Left = "left";
    h = Left;
  };
  directionR = rec {
    Right = "right";
    l = Right;
  };
  directionD = rec {
    Down = "down";
    j = Down;
  };
  directionU = rec {
    Up = "up";
    k = Up;
  };
  directionsX = directionL // directionR;
  directionsY = directionU // directionD;
  directions = directionsX // directionsY;
in
{
  programs.niri.settings = {
    binds =
      with config.lib.niri.actions;
      let
        sh = spawn "sh" "-c";
      in
      lib.attrsets.mergeAttrsList [
        {
          "Super+Shift+s".action = sh "systemctl suspend";
          "Super+Shift+p".action = sh "loginctl lock-session";

          "Super+q".action = close-window;

          "Super+Comma".action = consume-window-into-column;
          "Super+Period".action = expel-window-from-column;

          "Super+F".action = maximize-column;
          "Super+Shift+F".action = fullscreen-window;

          "Super+Space".action = switch-focus-between-floating-and-tiling;
          "Super+Shift+Space".action = toggle-window-floating;

          "Super+Minus".action = set-column-width "-10%";
          "Super+Shift+Minus".action = set-window-height "-10%";

          "Super+Equal".action = set-column-width "+10%";
          "Super+Shift+Equal".action = set-window-height "+10%";

          "Super+Shift+WheelScrollDown" = {
            cooldown-ms = 150;
            action = focus-workspace-down;
          };
          "Super+Shift+WheelScrollUp" = {
            cooldown-ms = 150;
            action = focus-workspace-up;
          };
          "Super+WheelScrollDown".action = focus-column-left;
          "Super+WheelScrollUp".action = focus-column-right;
        }
        (lib.concatMapAttrs (key: direction: {
          "Super+${key}".action."focus-workspace-${direction}" = { };
          "Super+Shift+${key}".action."move-column-to-workspace-${direction}" = { };
        }) directionsY)
        (lib.concatMapAttrs (key: direction: {
          "Super+${key}".action."focus-column-${direction}" = { };
          "Super+Shift+${key}".action."move-column-${direction}" = { };
        }) directionsX)
      ];
  };
}
