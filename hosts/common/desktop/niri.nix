{ pkgs, inputs, ... }:
{
  imports = [
    ./default.nix
    inputs.niri-flake.nixosModules.niri
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

  # programs.uwsm.enable = true;
  programs.niri = {
    package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    # package = inputs.niri-flake.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;
    enable = true;
  };
  programs.hyprlock.enable = true;

  networking.networkmanager.enable = true;

  # Fix broken file associations for dolphin
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
