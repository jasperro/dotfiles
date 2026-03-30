{ inputs, ... }:
{
  JDF.desktop._.niri = {
    nixos =
      { pkgs, ... }:
      {
        key = "niri";
        imports = [
          inputs.niri-nix.nixosModules.default
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

        programs.niri = {
          enable = true;
          package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        };

        networking.networkmanager.enable = true;

        # Fix broken file associations for dolphin
        environment.etc."xdg/menus/applications.menu".source =
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      };
  };
}
