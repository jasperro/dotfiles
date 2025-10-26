{ self, inputs, ... }:
{
  flake =
    _:
    let
      inherit (self) outputs;
      inherit (outputs) lib;

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
          users = [
            "wiktorine"
            "jasperro"
          ];
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
    in

    rec {
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
              inputs.determinate.nixosModules.default
              {
                # nixpkgs.buildPlatform = system;
                nixpkgs.hostPlatform = system;
                imports = [
                  inputs.impurity.nixosModules.impurity
                ];
                impurity.configRoot = self;
              }
              "${self}/hosts/${host}"
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
              value = inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = nixosConfigurations.${host}.pkgs;
                extraSpecialArgs = { inherit inputs outputs lib; };
                modules = [
                  {
                    imports = [
                      inputs.impurity.nixosModules.impurity
                    ];
                    impurity.configRoot = self;
                  }
                  "${self}/home/${user}/${host}"
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
