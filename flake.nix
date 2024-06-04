{
  description = "Jasperro's NixOS Config";

  inputs = rec {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs = nixpkgs-unstable;

    nur.url = "github:nix-community/NUR";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-colors.url = "github:misterio77/nix-colors";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Misterio77/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-unstable-small, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      lib = nixpkgs.lib // home-manager.lib;
    in
    rec {
      inherit lib;
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; });
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; });

      formatter =
        forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);

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
        tinkpet-wsl = {
          users = [ "nixos" ];
          system = "x86_64-linux";
        };
      };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = lib.listToAttrs (lib.mapAttrsToList
        (host: { system, ... }:
          let
            value = lib.nixosSystem {
              inherit system;
              specialArgs = {
                pkgs-stable = import nixpkgs-stable {
                  inherit system;
                  config.allowUnfree = true;
                };
                pkgs-unstable-small = import nixpkgs-unstable-small {
                  inherit system;
                  config.allowUnfree = true;
                };
                inherit inputs outputs;
              };
              modules = [
                ./hosts/${host}
              ];
            };
          in
          {
            name = host;
            inherit value;
          })
        hostPropsMap);

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = lib.listToAttrs (lib.mapAttrsToList
        (host: { users, ... }:
          lib.listToAttrs (lib.map
            (user:
              let
                value = home-manager.lib.homeManagerConfiguration {
                  pkgs = nixosConfigurations.${host}.pkgs;
                  extraSpecialArgs = { inherit inputs outputs; };
                  modules = [ ./home/${user}/${host} ];
                };
              in
              {
                name = "${user}@${host}";
                inherit value;
              })
            users))
        hostPropsMap);
    };
}
