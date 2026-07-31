{
  inputs,
  jdf,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.superlaptop = {
    description = "Dell laptop";
    users.wiktorine = {
      aspect = den.aspects."wiktorine@superlaptop";
      classes = [ "homeManager" ];
    };
    users.ewa = {
      aspect = den.aspects."ewa@superlaptop";
      classes = [ "homeManager" ];
    };
    users.jasperro = {
      aspect = den.aspects."jasperro@superlaptop";
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.superlaptop;
    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
        refreshRate = 60;
        workspace = "1";
        primary = true;
      }
    ];
  };

  den.aspects.superlaptop = {
    includes = [
      jdf.system._.audio
      jdf.system._.gui
      jdf.system._.home-locale
      jdf.system._.networking
      jdf.system._.nix-alien
      jdf.system._.nix-ld
      jdf.system._.nix
      jdf.system._.sops
      jdf.system._.utilities

      jdf.desktop._.plasma

      jdf.services._.openssh-inbound
      jdf.services._.timekpr
      jdf.services._.sunshine
    ];

    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.hardware.nixosModules.common-cpu-intel
          inputs.hardware.nixosModules.common-pc-laptop-ssd

          ./_hardware-configuration.nix
        ];

        hardware = {
          graphics = {
            enable = true;
            enable32Bit = true;
          };
          bluetooth.enable = true;
        };

        xdg.portal.enable = true;

        # Only *.enable, otherwise split to file in services/
        services = {
          flatpak.enable = true;
        };

        programs.gamemode.enable = true;

        fileSystems = {
          "/".options = [
            "rw"
            "noatime"
            "compress=zstd:3"
            "ssd"
          ];
          "/home".options = [
            "rw"
            "noatime"
            "compress=zstd:3"
            "ssd"
          ];
          "/nix".options = [
            "rw"
            "noatime"
            "compress=zstd:3"
            "ssd"
          ];
          "/.snapshots".options = [
            "rw"
            "noatime"
            "compress=zstd:3"
            "ssd"
          ];
          "/var".options = [
            "rw"
            "noatime"
            "compress=zstd:3"
            "ssd"
          ];
          "/boot".options = [
            "rw"
            "utf8"
          ];
        };

        boot = {
          tmp.useTmpfs = true;
          kernelPackages = pkgs.linuxPackages_zen;
          kernelModules = [ "i2c-dev" ];
          supportedFilesystems = [ "ntfs" ];
          loader = {
            systemd-boot = {
              enable = true;
              configurationLimit = 6;
              consoleMode = "max";
              netbootxyz.enable = true;
              memtest86.enable = true;
            };
            efi.canTouchEfiVariables = true;
          };
        };

        zramSwap = {
          enable = true;
          memoryPercent = 40;
          priority = 10;
        };

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "22.11";
      };
  };
}
