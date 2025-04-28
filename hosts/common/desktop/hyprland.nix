{ pkgs, ... }:
{
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
    hypridle.enable = true;
    #displayManager = {
    #  ly = {
    #    enable = true;
    #  };
    #  defaultSession = "hyprland-uwsm";
    #};
    greetd = {
    	enable = true;
	settings = {
		default_session = {
			command = "${pkgs.greetd.tuigreet}/bin/tuigreet  --time";
			user = "greeter";
		};
	};
    };
  };

  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    systemd.setPath.enable = true;
    withUWSM = true;
  };
  programs.hyprlock.enable = true;

  networking.networkmanager.enable = true;
}
