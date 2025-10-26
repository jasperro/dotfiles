{ self, inputs, ... }:
let
  inherit (self) outputs;
  inherit (outputs) lib;
in
{
  flake = _: {
    overlays = {
      default =
        final: prev:
        let
          additions =
            final: _:
            import "${self}/pkgs" {
              pkgs = final;
              inherit self lib;
            };

          modifications = final: prev: { };

          # nixpkgs-stable = final: _: {
          #   stable = import inputs.nixpkgs-stable {
          #     inherit (final) system;
          #     config.allowUnfree = true;
          #   };
          # };

          # nixpkgs-unstable = final: _: {
          #   stable = import inputs.nixpkgs-unstable {
          #     inherit (final) system;
          #     config.allowUnfree = true;
          #   };
          # };

          # nixpkgs-unstable-small = final: _: {
          #   stable = import inputs.nixpkgs-unstable-small {
          #     inherit (final) system;
          #     config.allowUnfree = true;
          #   };
          # };
        in
        (additions final prev) // (modifications final prev)
      # // (nixpkgs-stable final prev)
      # // (nixpkgs-unstable final prev)
      # // (nixpkgs-unstable-small final prev)
      ;
    };
  };
}
