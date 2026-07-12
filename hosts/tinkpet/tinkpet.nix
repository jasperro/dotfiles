{
  inputs,
  __findFile,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.tinkpet = {
    description = "Lenovo ThinkPad L15 Gen 2 AMD.";
    users.jasperro = {
      aspect = den.aspects."jasperro@tinkpet";
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.tinkpet;
  };

  den.aspects.tinkpet = {
    includes = [
      <JDF/system/audio>
      <JDF/system/gui>
      <JDF/system/home-locale>
      <JDF/system/networking>
      <JDF/system/nix-alien>
      <JDF/system/nix-ld>
      <JDF/system/nix>
      <JDF/system/sops>
      <JDF/system/utilities>

      <JDF/services/podman>
    ];

    provides.to-users = {
      homeManager = {
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
    };

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
        };

        programs.gamemode.enable = true;

        # Enable wifi using networkmanager
        networking.networkmanager.enable = true;

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
        system.stateVersion = "25.05";
      };
  };
}
