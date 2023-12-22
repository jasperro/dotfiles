{
  description = "Jasperro's NixOS Config";

  inputs = rec {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs = nixpkgs-stable;
    nur.url = "github:nix-community/NUR";
    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:mic92/sops-nix";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-colors.url = "github:misterio77/nix-colors";

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astronvim.url = "github:AstroNvim/AstroNvim";
    astronvim.flake = false;

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:max-privatevoid/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Misterio77/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nur
    , home-manager
    , nixpak
    , ...
    }@inputs:
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
        in import ./pkgs { inherit pkgs nixpak; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit nixpak; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        doosje = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/doosje ];
        };
        taart = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/taart ];
        };
        superlaptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/superlaptop ];
        };
        waffie = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/waffie ];
        };
        tinkpet-wsl = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/tinkpet-wsl ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'

      homeConfigurations = {
        "jasperro@doosje" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixosConfigurations.doosje.pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/jasperro/doosje ];
        };
        "jasperro@taart" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixosConfigurations.taart.pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/jasperro/taart ];
        };
        "nixos@tinkpet-wsl" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixosConfigurations.tinkpet-wsl.pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/jasperro/tinkpet-wsl ];
        };
        "colin@superlaptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixosConfigurations.superlaptop.pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/colin/superlaptop ];
        };
        "wiktorine@waffie" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixosConfigurations.waffie.pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/wiktorine/waffie ];
        };
      };
    };
}
