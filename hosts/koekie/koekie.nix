{
  inputs,
  jdf,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.koekie = {
    description = "Wiktorine's desktop.";
    users.wiktorine = {
      aspect = den.aspects."wiktorine@koekie";
      classes = [ "homeManager" ];
    };
    users.jasperro = {
      aspect = den.aspects."jasperro@koekie";
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.koekie;
  };

  den.aspects.koekie = {
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
          inputs.hardware.nixosModules.common-cpu-amd
          inputs.hardware.nixosModules.common-cpu-amd-pstate
          inputs.hardware.nixosModules.common-gpu-amd
          inputs.hardware.nixosModules.common-pc-ssd

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
          uinput.enable = true;
        };

        services.xserver.videoDrivers = [ "amdgpu" ];
        xdg.portal.enable = true;

        # Only *.enable, otherwise split to file in services/
        services = {
          ratbagd.enable = true;
          flatpak.enable = true;
          fwupd.enable = true;
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
          "/.snapshots".options = [
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
