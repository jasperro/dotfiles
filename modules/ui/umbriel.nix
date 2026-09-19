{
  inputs,
  jdfPath,
  lib,
  ...
}:
{
  flake-file.inputs = {
    umbriel = {
      url = "git+https://github.com/noctalia-dev/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  jdf = lib.setAttrByPath jdfPath {
    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.umbriel.nixosModules.default
        ];

        programs.umbriel.enable = true;

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
                command = "${pkgs.tuigreet}/bin/tuigreet --time";
                user = "greeter";
              };
            };
          };
        };

        networking.networkmanager.enable = true;

        # Fix broken file associations for dolphin
        environment.etc."xdg/menus/applications.menu".source =
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      };
  };
}
