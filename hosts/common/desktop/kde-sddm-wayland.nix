{ pkgs, ... }: {
  imports = [ ./default.nix ];
  services.xserver = {
    enable = true;
    layout = "us";
    dpi = 108;
    xkbVariant = "altgr-intl";
    xkbOptions = "terminate:ctrl_alt_bksp";
    displayManager = {
      sddm = {
      	enable = true;
	wayland.enable = true;
      	settings = {
          Theme = { CursorTheme = "breeze_cursors"; };
	};
      };
      defaultSession = "plasmawayland";
    };
    desktopManager.plasma5.enable = true;
  };

  networking.networkmanager.enable = true;
}
