{ pkgs, inputs, ... }:
{
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  nixpkgs = {
    overlays = [ inputs.waybar.overlays.default ];
  };
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
          command = "${pkgs.tuigreet}/bin/tuigreet  --time";
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
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  programs.hyprlock.enable = true;

  networking.networkmanager.enable = true;

  # Fix broken file associations for dolphin
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
