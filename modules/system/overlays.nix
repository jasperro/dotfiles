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
        ];
      };
  };
}
