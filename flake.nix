{
  description = "Jasperro's NixOS Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nur.url = "github:nix-community/NUR";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # hardware.url = "github:nixos/nixos-hardware";

    astronvim.url = "github:AstroNvim/AstroNvim";
    astronvim.flake = false;

    nix-minecraft = {
      url = "github:infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Minecraft server plugins, in flake.nix instead of fetchurl because...
    EssentialsX.url = "https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsX-2.19.7.jar";
    EssentialsX.flake = false;
    EssentialsXChat.url = "https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsXChat-2.19.7.jar";
    EssentialsXChat.flake = false;
    EssentialsXSpawn.url = "https://github.com/EssentialsX/Essentials/releases/download/2.19.7/EssentialsXSpawn-2.19.7.jar";
    EssentialsXSpawn.flake = false;
    FAWE.url = "https://cdn.modrinth.com/data/z4HZZnLr/versions/o3DnEEKh/FastAsyncWorldEdit-Bukkit-2.5.0.jar";
    FAWE.flake = false;
    DecentHolograms.url = "https://github.com/DecentSoftware-eu/DecentHolograms/releases/download/2.7.9/DecentHolograms-2.7.9.jar";
    DecentHolograms.flake = false;
    CleanroomGenerator.url = "https://mediafilez.forgecdn.net/files/3596/715/CleanroomGenerator-1.2.1.jar";
    CleanroomGenerator.flake = false;
    Geyser.url = "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/build/libs/Geyser-Spigot.jar";
    Geyser.flake = false;
    Floodgate.url = "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs/floodgate-spigot.jar";
    Floodgate.flake = false;
    HeadDB.url = "https://github.com/TheSilentPro/HeadDB/releases/download/4.4.4/HeadDB-4.4.4.jar";
    HeadDB.flake = false;
    MultiverseCore.url = "https://ci.onarandombox.com/view/Multiverse/job/Multiverse-Core/lastSuccessfulBuild/artifact/target/Multiverse-Core-4.3.2-SNAPSHOT.jar";
    MultiverseCore.flake = false;
    MultiverseInventories.url = "https://ci.onarandombox.com/view/Multiverse/job/Multiverse-Inventories/lastSuccessfulBuild/artifact/target/Multiverse-Inventories-4.2.4-SNAPSHOT.jar";
    MultiverseInventories.flake = false;
    MultiverseNetherPortals.url = "https://ci.onarandombox.com/view/Multiverse/job/Multiverse-NetherPortals/lastSuccessfulBuild/artifact/target/Multiverse-NetherPortals-4.2.3-SNAPSHOT.jar";
    MultiverseNetherPortals.flake = false;
    MultiverseSignPortals.url = "https://ci.onarandombox.com/view/Multiverse/job/Multiverse-SignPortals/lastSuccessfulBuild/artifact/target/Multiverse-SignPortals-4.2.1-SNAPSHOT.jar";
    MultiverseSignPortals.flake = false;
    Vault.url = "https://github.com/MilkBowl/Vault/releases/download/1.7.3/Vault.jar";
    Vault.flake = false;
  };

  outputs = { self, nixpkgs, nur, home-manager, astronvim, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays;
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
            # > Our main nixos configuration file <
            ./nixos/configuration.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "jasperro@doosje" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/home.nix
          ];
        };
      };
    };
}
