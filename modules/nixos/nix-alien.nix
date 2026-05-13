{ inputs, __findFile, ... }:
{
  flake-file.inputs = {
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
  };

  JDF.nixos._.nix-alien = {
    includes = [ <JDF/nixos/nix-ld> ];
    nixos =
      { pkgs, ... }:
      {
        key = "nix-alien";
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
