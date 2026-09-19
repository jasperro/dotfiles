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
        wayland.windowManager.niri.settings.binds = mkKeybinds {
          inherit config pkgs inputs;
          modKey = "Super";

          mkWheel = prefix: dir: "${prefix}+WheelScroll${dir}";

          mkSpawn = cmdList: { spawn = cmdList; };
          mkSpawnSh = cmdStr: { spawn-sh = cmdStr; };
          mkNoctalia = cmd: {
            spawn = [
              "noctalia"
              "msg"
            ]
            ++ (lib.splitString " " cmd);
          };

          mkWmAction =
            action:
            {
              "overview-toggle" = {
                toggle-overview = [ ];
              };
              "window-close" = {
                close-window = [ ];
              };
              "window-consume-left" = {
                consume-window-into-column = [ ];
              };
              "window-consume-right" = {
                expel-window-from-column = [ ];
              };
              "window-cycle-primary-extent" = {
                switch-preset-column-width = [ ];
              };
              "window-toggle-maximize-to-edges" = {
                maximize-window-to-edges = [ ];
              };
              "window-toggle-maximize" = {
                maximize-column = [ ];
              };
              "window-toggle-fullscreen" = {
                fullscreen-window = [ ];
              };
              "window-focus-switch-floating" = {
                switch-focus-between-floating-and-tiling = [ ];
              };
              "window-toggle-floating" = {
                toggle-window-floating = [ ];
              };
              "window-resize-width-dec" = {
                set-column-width = "-10%";
              };
              "window-resize-height-dec" = {
                set-window-height = "-10%";
              };
              "window-resize-width-inc" = {
                set-column-width = "+10%";
              };
              "window-resize-height-inc" = {
                set-window-height = "+10%";
              };
              "window-focus-previous" = {
                focus-column-left = [ ];
              };
              "window-focus-next" = {
                focus-column-right = [ ];
              };
              "workspace-previous" = {
                focus-workspace-up = [ ];
              };
              "workspace-next" = {
                focus-workspace-down = [ ];
              };
              "focus-y-down" = {
                focus-workspace-down = [ ];
              };
              "focus-y-up" = {
                focus-workspace-up = [ ];
              };
              "move-y-down" = {
                move-column-to-workspace-down._props.focus = false;
              };
              "move-y-up" = {
                move-column-to-workspace-up._props.focus = false;
              };
              "focus-x-left" = {
                focus-column-left = [ ];
              };
              "focus-x-right" = {
                focus-column-right = [ ];
              };
              "move-x-left" = {
                move-column-left = [ ];
              };
              "move-x-right" = {
                move-column-right = [ ];
              };
              "window-consume-or-expel-right" = {
                focus-column-left = [ ];
              };
              "window-consume-or-expel-left" = {
                focus-column-right = [ ];
              };
            }
            .${action} or { };

          mkWithOptions =
            action: opts:
            action
            // {
              _props.cooldown-ms = opts.cooldown_ms or 0;
            };
        };
      };
  };
}
