{
  jdfPath,
  lib,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath {
    nixos =
      {
        ...
      }:
      {
        nixpkgs.overlays = [
          # https://github.com/mio-19/config-public/commit/ddc319b74af8ae0fb0024c4fddcdcc424ddc7fd9
          # https://github.com/GreepTheSheep/nixos-config/commit/9da31efa2517982ab9f1943c9d98af65fa95b53d
          # Node.js 26 runs test-fs-cp-async-file-modes, which chmods the setuid
          # and setgid bits. Those chmods return EPERM inside the Nix build
          # sandbox, so the test can never pass and the whole nodejs build fails.
          # Upstream skips it too: https://github.com/NixOS/nixpkgs/issues/564449
          # Drop this overlay once nixpkgs-unstable carries the upstream fix.
          (_: prev: {
            nodejs-slim_26 = prev.nodejs-slim_26.overrideAttrs (old: {
              checkFlags = map (
                flag: if lib.hasPrefix "CI_SKIP_TESTS=" flag then "${flag},test-fs-cp-async-file-modes" else flag
              ) old.checkFlags;
            });
          })
        ];
      };
  };
}
