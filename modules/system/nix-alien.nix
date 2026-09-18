{
  inputs,
  lib,
  jdf,
  jdfPath,
  ...
}:
{
  flake-file.inputs = {
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "flake-compat";
    };
  };

  jdf = lib.setAttrByPath jdfPath {
    includes = [ jdf.system._.nix-ld ];
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
