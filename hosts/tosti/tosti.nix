{
  inputs,
  __findFile,
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
      <JDF/nixos/audio>
      <JDF/nixos/gui>
      <JDF/nixos/home-locale>
      <JDF/nixos/networking>
      <JDF/nixos/nix-alien>
      <JDF/nixos/nix-ld>
      <JDF/nixos/nix>
      <JDF/nixos/sops>
      <JDF/nixos/utilities>

      <JDF/services/podman>

      <tosti/disko-config>
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
        key = "tosti";
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
