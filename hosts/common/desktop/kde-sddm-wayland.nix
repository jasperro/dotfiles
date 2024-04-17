{ pkgs, ... }: {
  imports = [ ./default.nix ];
  services = {
    xserver = {
      enable = true;
      dpi = 108;
      xkb = {
        layout = "us";
        variant = "altgr-intl";
        options = "terminate:ctrl_alt_bksp";
      };
    };
    desktopManager.plasma6.enable = true;
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
  };

  networking.networkmanager.enable = true;
}
