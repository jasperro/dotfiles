{ lib, ... }:
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
  # directions = directionsX // directionsY;
in
{
  wayland.windowManager.niri.settings = {
    binds = lib.attrsets.mergeAttrsList [
      {
        "Super+Shift+S".spawn = [
          "systemctl"
          "suspend"
        ];
        "Super+Shift+P".spawn = [
          "loginctl"
          "lock-session"
        ];

        "Super+D".toggle-overview = [ ];
        "Super+Tab".toggle-overview = [ ];

        "Super+Q".close-window = [ ];

        "Super+Comma".consume-window-into-column = [ ];
        "Super+Period".expel-window-from-column = [ ];
        "Super+Slash".switch-preset-column-width = [ ];

        "Super+F".maximize-column = [ ];
        "Super+Shift+F".fullscreen-window = [ ];

        "Super+Shift+Space".switch-focus-between-floating-and-tiling = [ ];
        "Super+Space".toggle-window-floating = [ ];

        "Super+Minus".set-column-width = "-10%";
        "Super+Shift+Minus".set-window-height = "-10%";

        "Super+Equal".set-column-width = "+10%";
        "Super+Shift+Equal".set-window-height = "+10%";

        "Super+Control+WheelScrollDown" = {
          focus-workspace-down = [ ];
          _props.cooldown-ms = 150;
        };
        "Super+Control+WheelScrollUp" = {
          focus-workspace-up = [ ];
          _props.cooldown-ms = 150;
        };
        "Super+WheelScrollUp".focus-column-left = [ ];
        "Super+WheelScrollDown".focus-column-right = [ ];
      }
      (lib.concatMapAttrs (key: direction: {
        "Super+${key}"."focus-workspace-${direction}" = [ ];
        "Super+Shift+${key}" = {
          "move-column-to-workspace-${direction}" = {
            _props.focus = false;
          };
        };
      }) directionsY)
      (lib.concatMapAttrs (key: direction: {
        "Super+${key}"."focus-column-${direction}" = [ ];
        "Super+Shift+${key}"."move-column-${direction}" = [ ];
      }) directionsX)
    ];
  };
}
