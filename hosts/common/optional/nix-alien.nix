{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; with inputs.nix-alien.packages.${system}; [
    nix-alien
    nix-index # not necessary, but recommended
    nix-index-update
  ];
  # Optional, needed for `nix-alien-ld`
  programs.nix-ld.enable = true;
}
