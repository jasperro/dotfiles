{ lib, ... }:
let
  # Map keys to hyprland directions
  directionL = rec {
    left = "l";
    h = left;
  };
  directionR = rec {
    right = "r";
    l = right;
  };
  directionD = rec {
    down = "d";
    j = down;
  };
  directionU = rec {
    up = "u";
    k = up;
  };
  directionsX = directionL // directionR;
  directionsY = directionU // directionD;
  directions = directionsX // directionsY;
in
{
  wayland.windowManager.hyprland.settings = {
    bindm = [
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];

    bind = [
      "SUPERSHIFT,s,exec,systemctl suspend"
      "SUPERSHIFT,p,exec,loginctl lock-session"

      "SUPER,q,killactive"

      "SUPER,s,togglesplit"
      "SUPER,f,fullscreen,1"
      "SUPERSHIFT,f,fullscreen,0"
      "SUPER,space,togglefloating"

      "SUPER,minus,splitratio,-0.25"
      "SUPERSHIFT,minus,splitratio,-0.3333333"

      "SUPER,equal,splitratio,0.25"
      "SUPERSHIFT,equal,splitratio,0.3333333"

      "SUPER,g,togglegroup"
      "SUPERSHIFT,g,moveoutofgroup"
      "SUPER,apostrophe,changegroupactive,f"
      "SUPERSHIFT,apostrophe,changegroupactive,b"

      "SUPER,u,togglespecialworkspace"
      "SUPERSHIFT,u,movetoworkspace,special"

      "SUPER,grave,overview:toggle,all"

      "SUPER,mouse_up,workspace,e+1"
      "SUPER,mouse_down,workspace,e-1"
    ]
    ++
      # Move workspace next
      (lib.mapAttrsToList (key: direction: "SUPERCONTROL,${key},workspace,e+1") directionR)
    ++
      # Move workspace prev
      (lib.mapAttrsToList (key: direction: "SUPERCONTROL,${key},workspace,e-1") directionL)
    ++
      # Move focus
      (lib.mapAttrsToList (key: direction: "SUPER,${key},movefocus,${direction}") directions)
    ++
      # Swap windows
      (lib.mapAttrsToList (key: direction: "SUPERSHIFT,${key},swapwindow,${direction}") directions)
    ++
      # Move monitor focus
      (lib.mapAttrsToList (key: direction: "SUPERCONTROL,${key},focusmonitor,${direction}") directions)
    ++
      # Move window to other monitor
      (lib.mapAttrsToList (
        key: direction: "SUPERCONTROLSHIFT,${key},movewindow,mon:${direction}"
      ) directions)
    ++
      # Move workspace to other monitor
      (lib.mapAttrsToList (
        key: direction: "SUPERALT,${key},movecurrentworkspacetomonitor,${direction}"
      ) directions);
  };
}
