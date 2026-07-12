{ inputs, __findFile, ... }:
{
  flake-file.inputs = {
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
  };

  JDF.system._.nix-alien = {
    includes = [ <JDF/system/nix-ld> ];
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages =
          with pkgs;
          with inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system};
          [
            nix-alien
            nix-index # not necessary, but recommended
            nix-index-update
          ];
      };
  };
}
