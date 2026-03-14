{ inputs, ... }:
{
  flake = _: {
    lib = inputs.nixpkgs.lib.extend (_: _: inputs.home-manager.lib);
  };
}
