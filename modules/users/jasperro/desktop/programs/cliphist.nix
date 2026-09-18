{ lib, jdfPath, ... }:
{
  jdf = lib.setAttrByPath jdfPath {
    homeManager = {
      services.cliphist = {
        enable = true;
        allowImages = true;
      };
    };
  };
}
