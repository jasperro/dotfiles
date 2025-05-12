{ impurity, ... }: {
    imports = [
      ../../../../common/features/desktop/hyprland
    ];
    wayland.windowManager.hyprland.settings = {
        source = [(toString (impurity.link ./input.conf))];
    };
}