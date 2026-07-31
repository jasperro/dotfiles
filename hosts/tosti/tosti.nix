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
    encrypted-btrfs-filesystem = {
      enable = true;
      partitions = {
        boot = "/dev/disk/by-uuid/90D4-E485";
        luks = "/dev/disk/by-uuid/6241c212-ec7c-464c-b5bf-4971e8cd1987";
      };
    };
    monitors = [
      {
        name = "eDP-1";
        width = 2560;
        height = 1600;
        refreshRate = 144;
        workspace = "1";
        primary = true;
        vrr = true;
        scale = 1.35;
      }
    ];
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
    ];

    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.hardware.nixosModules.common-cpu-intel
          inputs.hardware.nixosModules.common-pc-ssd

          ./_hardware-configuration.nix
        ];

        hardware = {
          graphics = {
            enable = true;
          };
        };

        systemd.tpm2.enable = true;

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

        environment.systemPackages = with pkgs; [
          sof-firmware
          alsa-firmware
          alsa-ucm-conf
          alsa-utils
        ];

        hardware.enableAllFirmware = true;

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "26.05";
      };
  };
}
