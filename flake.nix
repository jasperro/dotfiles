{
  description = "Jasperro's NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpak = {
      url = "github:max-privatevoid/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

    astronvim.url = "github:AstroNvim/AstroNvim";
    astronvim.flake = false;

    nix-minecraft = {
      url = "github:Misterio77/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:mic92/sops-nix";
    nix-alien.url = "github:thiagokokada/nix-alien";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , nur
    , home-manager
    , nixpak
    , ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      nurNoPkgs = import nur {
        nurpkgs = nixpkgs.legacyPackages.x86_64-linux;
        pkgs = throw "nixpkgs eval";
      };
    in
    rec {
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
          modules = [
            ./hosts/doosje
          ];
        };
        taart = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/taart
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.buildPlatform.system = "x86_64-linux";
            }
          ];
        };
        superlaptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/superlaptop
          ];
        };
        waffie = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/waffie
          ];
        };
        tinkpet-wsl = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/tinkpet-wsl
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'

      homeConfigurations = {
        "jasperro@doosje" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs outputs nurNoPkgs; };
          modules = [
            nur.hmModules.nur
            ./home/jasperro/doosje
          ];
        };
        "jasperro@taart" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;

          extraSpecialArgs = { inherit inputs outputs nurNoPkgs; };
          modules = [
            ./home/jasperro/taart
          ];
        };
        "nixos@tinkpet-wsl" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs outputs nurNoPkgs; };
          modules = [
            ./home/jasperro/tinkpet-wsl
          ];
        };
        "colin@superlaptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs outputs nurNoPkgs; };
          modules = [
            ./home/colin/superlaptop
          ];
        };
        "wiktorine@waffie" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;

          extraSpecialArgs = { inherit inputs outputs nurNoPkgs; };
          modules = [
            ./home/wiktorine/waffie
          ];
        };
      };
    };
}
