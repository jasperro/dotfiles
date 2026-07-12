{
  lib,
  jdf,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.ijsje = {
    description = "Custom NixOS installer ISO.";
    users.jasperro = {
      aspect = den.aspects."jasperro@ijsje";
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.ijsje;
  };

  den.aspects.ijsje = {
    includes = [
      jdf.system._.audio
      jdf.system._.gui
      jdf.system._.home-locale
      jdf.system._.networking
      jdf.system._.nix-alien
      jdf.system._.nix-ld
      jdf.system._.nix
      jdf.system._.utilities
    ];

    nixos =
      { modulesPath, config, ... }:
      {
        imports = [
          "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
        ];

        system.stateVersion = "26.11";

        lib.isoFileSystems."/home/jasperro" = {
          device = "/dev/disk/by-label/jasperro";
          fsType = "ext4";
        };

        users.users.nixos.uid = 1001;

        isoImage.edition = lib.mkDefault config.networking.hostName;
        networking.networkmanager.enable = true;
        networking.wireless.enable = true;

        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = true;
        services.blueman.enable = true;
        services.pulseaudio.enable = false;
      };
  };
}
