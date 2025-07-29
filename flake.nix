{
  description = "Jasperro's NixOS Config";

  inputs = {
    systems = {
      url = "path:flake.systems.nix";
      flake = false;
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    flake-compat.url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    # nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Misterio77/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    impurity.url = "github:outfoxxed/impurity.nix";

    waybar = {
      url = "github:jasperro/Waybar/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hypr-darkwindow = {
      url = "github:micha4w/Hypr-DarkWindow";
      inputs.hyprland.follows = "hyprland";
    };

    wofi-power-menu = {
      url = "github:szaffarano/wofi-power-menu";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    {
      self,
      systems,
      determinate,
      nixpkgs,
      # nixpkgs-stable,
      # nixpkgs-unstable-small,
      home-manager,
      impurity,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs (import systems);
      # Customize lib with custom lib
      lib = nixpkgs.lib.extend (_: _: import ./lib // home-manager.lib);
    in
    rec {
      inherit lib;
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./shell.nix { inherit pkgs; }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays;
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      hostPropsMap = {
        doosje = {
          users = [ "jasperro" ];
          system = "x86_64-linux";
        };
        taart = {
          users = [ "jasperro" ];
          system = "aarch64-linux";
          crossBuildPlatforms = [ "x86_64-linux" ];
        };
        superlaptop = {
          users = [ "colin" ];
          system = "x86_64-linux";
        };
        waffie = {
          users = [ "wiktorine" ];
          system = "x86_64-linux";
        };
        koekie = {
          users = [ "wiktorine" ];
          system = "x86_64-linux";
        };
        tinkpet = {
          users = [ "jasperro" ];
          system = "x86_64-linux";
        };
        tinkpet-wsl = {
          users = [ "nixos" ];
          system = "x86_64-linux";
        };
      };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = lib.concatMapAttrs (
        host:
        {
          system,
          crossBuildPlatforms ? [ ],
          ...
        }:
        let
          value = lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
            modules = [
              determinate.nixosModules.default
              {
                # nixpkgs.buildPlatform = system;
                nixpkgs.hostPlatform = system;
                imports = [
                  impurity.nixosModules.impurity
                ];
                impurity.configRoot = self;
              }
              ./hosts/${host}
            ];
          };
        in
        {
          ${host} = value;
          "${host}-impure" = self.nixosConfigurations.${host}.extendModules {
            modules = [ { impurity.enable = true; } ];
          };
        }
        # Cross compile for RPi only, can change this if needed.
        // lib.mergeAttrsList (
          map (bp: {
            "${host}-cc-${bp}" = self.nixosConfigurations.${host}.extendModules {
              modules = [
                {
                  nixpkgs.buildPlatform = bp;
                }
              ];
            };
          }) crossBuildPlatforms
        )
      ) hostPropsMap;

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = lib.concatMapAttrs (
        host:
        { users, ... }:
        lib.mergeAttrsList (
          map (
            user:
            let
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixosConfigurations.${host}.pkgs;
                extraSpecialArgs = { inherit inputs outputs lib; };
                modules = [
                  {
                    imports = [
                      impurity.nixosModules.impurity
                    ];
                    impurity.configRoot = self;
                  }
                  ./home/${user}/${host}
                ];
              };
            in
            {
              "${user}@${host}" = value;
              "${user}@${host}-impure" = value.extendModules { modules = [ { impurity.enable = true; } ]; };
            }
          ) users
        )
      ) hostPropsMap;
    };
}
