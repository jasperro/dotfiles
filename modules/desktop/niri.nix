{ inputs, ... }:
{
  flake-file.inputs = {
    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  jdf.desktop._.niri = {
    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.niri-nix.nixosModules.default
        ];

        nixpkgs.overlays = [ inputs.niri-nix.overlays.niri-nix ];

        # nix.settings = {
        #   substituters = [
        #     "https://niri-nix.cachix.org"
        #   ];
        #   trusted-public-keys = [
        #     "niri-nix.cachix.org-1:SvFtqpDcf7Sm1SMJdby1/+Y+6f3Yt3/3PMcSTKPJNJ0="
        #   ];
        # };

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
          # package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
          package = pkgs.niri-unstable;
        };

        networking.networkmanager.enable = true;

        # Fix broken file associations for dolphin
        environment.etc."xdg/menus/applications.menu".source =
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      };
  };
}
