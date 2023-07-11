{ pkgs, ... }: {
  imports = [ ./desktop.nix ];
  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 108;
    xkbVariant = "altgr-intl";
    xkbOptions = "terminate:ctrl_alt_bksp";
    displayManager = {
      sddm.enable = true;
      sddm.settings = {
        Theme = { CursorTheme = "breeze_cursors"; };
        General = {
          DisplayServer = "wayland";
          InputMethod = "";
        };
        Wayland.CompositorCommand = "${pkgs.weston}/bin/weston --shell=fullscreen-shell.so";
      };
      defaultSession = "plasmawayland";
    };
    desktopManager.plasma5.enable = true;
  };

  networking.networkmanager.enable = true;
}
