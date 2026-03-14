{ pkgs, inputs, ... }:
{
  imports = [ ./nix-ld.nix ];
  environment.systemPackages =
    with pkgs;
    with inputs.nix-alien.packages.${pkgs.stdenv.hostPlatform.system};
    [
      nix-alien
      nix-index # not necessary, but recommended
      nix-index-update
    ];
}
