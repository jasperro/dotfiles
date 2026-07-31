{
  inputs,
  jdf,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.doosje = {
    description = "Main desktop computer, used for gaming and general use.";
    users.jasperro = {
      aspect = den.aspects."jasperro@doosje";
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.doosje;
    monitors = [
      {
        name = "DP-3";
        width = 2560;
        height = 1440;
        refreshRate = 180.01;
        workspace = "1";
        primary = true;
        vrr = true;
      }
    ];
  };

  den.aspects.doosje = {
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
      jdf.services._.disable-usb-wakeup
    ];

    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.hardware.nixosModules.common-cpu-amd
          inputs.hardware.nixosModules.common-cpu-amd-pstate
          inputs.hardware.nixosModules.common-gpu-amd
          inputs.hardware.nixosModules.common-pc-ssd

          ./_services/samba.nix
          ./_hardware-configuration.nix
        ];

        hardware = {
          graphics = {
            enable = true;
          };
          amdgpu = {
            opencl.enable = true;
          };
          xone.enable = true;
        };

        services.wivrn = {
          enable = true;
          openFirewall = true;
          autoStart = true;
        };

        programs.appimage = {
          enable = true;
          binfmt = true;
        };

        services.xserver.videoDrivers = [ "amdgpu" ];
        xdg.portal.enable = true;

        # Only *.enable, otherwise split to file in services/
        services = {
          ratbagd.enable = true;
          flatpak.enable = true;
          fwupd.enable = true;
          hardware.openrgb = {
            enable = true;
            package = pkgs.openrgb-with-all-plugins;
          };
        };

        programs.gamemode.enable = true;

        # Overclock gpu support
        # programs.corectrl = {
        #   enable = true;
        #   gpuOverclock = {
        #     enable = true;
        #     ppfeaturemask = "0xffffffff";
        #   };
        # };

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

          "/media/Windows10" = {
            device = "/dev/disk/by-uuid/14743E80743E64A0";
            fsType = "ntfs";
            options = [
              "defaults"
              "rw"
              "noatime"
              "uid=1000"
              "gid=1000"
              "fmask=0133"
              "dmask=0022"
            ];
          };

          "/media/OldSSD" = {
            device = "/dev/disk/by-uuid/7bf18a03-c38b-427f-b0be-fa7eb5d18643";
            fsType = "btrfs";
            options = [
              "rw"
              "noatime"
              "compress=zstd:3"
              "ssd"
              "subvol=bestanden"
            ];
          };
        };

        boot = {
          tmp.useTmpfs = true;
          kernelPackages = pkgs.linuxPackages_zen;
          kernelModules = [ "i2c-dev" ];
          kernelParams = [ "amd_pstate.shared_mem=1" ];
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
          binfmt.emulatedSystems = [ "aarch64-linux" ];
          binfmt.preferStaticEmulators = true;
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
        system.stateVersion = "22.11";
      };
  };
}
