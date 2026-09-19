{
  inputs,
  jdfPath,
  lib,
  ...
}:
let
  keybindsLib = import ../_lib/keybinds.nix { inherit lib; };
  mkKeybinds = keybindsLib.mkBinds;
in
{
  jdf = lib.setAttrByPath jdfPath {
    homeManager =
      { config, pkgs, ... }:
      {
        programs.umbriel.settings.hot_corners.top_left = {
          enabled = true;
          delay_ms = 200;
          action = "overview-open";
        };

        programs.umbriel.settings.keybinds = mkKeybinds {
          inherit config pkgs inputs;
          modKey = "Mod";

          mkWheel = prefix: dir: "${prefix}+Wheel${dir}";

          mkSpawn = cmdList: "spawn:${lib.concatStringsSep " " cmdList}";
          mkSpawnSh = cmdStr: "spawn:${cmdStr}";
          mkNoctalia = cmd: "spawn:noctalia msg ${cmd}";

          mkWmAction =
            action:
            {
              "window-resize-width-dec" = "window-modify-width-right:-0.1";
              "window-resize-height-dec" = "window-modify-height-down:-0.1";
              "window-resize-width-inc" = "window-modify-width-right:+0.1";
              "window-resize-height-inc" = "window-modify-height-down:+0.1";
              "window-consume-right" = "window-consume-or-expel-right";
              "window-consume-left" = "window-consume-left";
              "window-focus-previous" = "window-focus-next";
              "window-focus-next" = "window-focus-previous";
              "focus-y-down" = "window-focus-down";
              "focus-y-up" = "window-focus-up";
              "move-y-down" = "window-move-down";
              "move-y-up" = "window-move-up";
              "focus-x-left" = "window-focus-left";
              "focus-x-right" = "window-focus-right";
              "move-x-left" = "window-consume-or-expel-left";
              "move-x-right" = "window-consume-or-expel-right";
            }
            .${action} or action;

          mkWithOptions = action: opts: {
            action = action;
            cooldown_ms = opts.cooldown_ms or 0;
          };
        };
      };
  };
}
