{ pkgs, ... }: {
  imports = [ ./default.nix ];
  services.xserver = {
    enable = true;
    dpi = 108;
    xkb = {
      layout = "us";
      variant = "altgr-intl";
      options = "terminate:ctrl_alt_bksp";
    };
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        settings = {
          Theme = { CursorTheme = "breeze_cursors"; };
        };
      };
      defaultSession = "plasma";
    };
    desktopManager.plasma6.enable = true;
  };

  networking.networkmanager.enable = true;
}
