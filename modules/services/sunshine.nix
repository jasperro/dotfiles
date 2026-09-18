{ lib, jdfPath, ... }: {
  jdf = lib.setAttrByPath jdfPath {
    nixos = {
      services.sunshine = {
        enable = true;
        openFirewall = true;
        capSysAdmin = true;
        autoStart = true;
      };
    };
  };
}
