{ pkgs, inputs, ... }:
{
  nixpkgs = {
    overlays = [ inputs.niri.overlays.niri ];
  };
  imports = [
    ./default.nix
    inputs.niri.nixosModules.niri
  ];
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
  programs.niri = {
    enable = true;
  };
  programs.hyprlock.enable = true;

  networking.networkmanager.enable = true;

  # Fix broken file associations for dolphin
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
