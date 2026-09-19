{
  jdfPath,
  lib,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath {
    os =
      {
        ...
      }:
      {
        nixpkgs.overlays = [
        ];
      };
  };
}
