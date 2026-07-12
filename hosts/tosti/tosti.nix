{
  inputs,
  jdf,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.tosti = {
    description = "Lenovo Yoga Slim 7 14ILL10.";
    users.jasperro = {
      aspect = den.aspects."jasperro@tosti";
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.tosti;
  };

  den.aspects.tosti = {
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

      jdf.services._.podman

      den.aspects.tosti._.disko-config
    ];

    provides.to-users = {
      homeManager = {
        monitors = [
          {
            name = "eDP-1";
            width = 2880;
            height = 1800;
            refreshRate = 120;
            workspace = "1";
            primary = true;
          }
        ];
      };
    };

    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.hardware.nixosModules.lenovo-yoga-7-14ILL10

          ./_hardware-configuration.nix
        ];

        hardware = {
          graphics = {
            enable = true;
          };
        };

        programs.appimage = {
          enable = true;
          binfmt = true;
        };

        xdg.portal.enable = true;

        # Only *.enable, otherwise split to file in services/
        services = {
          ratbagd.enable = true;
          flatpak.enable = true;
          fwupd.enable = true;
        };

        programs.gamemode.enable = true;

        # Enable wifi using networkmanager
        networking.networkmanager.enable = true;

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
          "/boot".options = [
            "rw"
            "relatime"
            "fmask=0022"
            "dmask=0022"
            "codepage=437"
            "iocharset=iso8859-1"
            "shortname=mixed"
            "utf8"
            "errors=remount-ro"
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
              memtest86.enable = true;
            };
            efi.canTouchEfiVariables = true;
          };
        };

        nixpkgs = {
          # You can add overlays here
          overlays = [ ];
        };

        zramSwap = {
          enable = true;
          memoryPercent = 40;
          priority = 10;
        };

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "25.11";
      };
  };
}
