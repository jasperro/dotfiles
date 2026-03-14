{ inputs, __findFile, ... }:
{
  JDF.nixos._.nix-alien = {
    includes = [ <JDF/nixos/nix-ld> ];
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
