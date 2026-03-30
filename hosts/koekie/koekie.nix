{
  inputs,
  __findFile,
  ...
}:
{
  den.hosts.x86_64-linux.koekie = {
    description = "Wiktorine's desktop.";
    users.wiktorine = {
      aspect = "wiktorine-koekie";
      classes = [ "homeManager" ];
    };
    users.jasperro = {
      aspect = "jasperro-koekie";
      classes = [ "homeManager" ];
    };
    aspect = "koekie";
  };

  den.aspects.koekie = {
    includes = [
      <JDF/nixos/determinate>

      <JDF/nixos/audio>
      <JDF/nixos/gui>
      <JDF/nixos/home-locale>
      <JDF/nixos/networking>
      <JDF/nixos/nix-alien>
      <JDF/nixos/nix-ld>
      <JDF/nixos/nix>
      <JDF/nixos/sops>
      <JDF/nixos/utilities>

      <JDF/desktop/plasma>

      <JDF/services/openssh-inbound>
      <JDF/services/timekpr>
      <JDF/services/sunshine>
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

        users.groups.wiktorine.gid = 1003;

        users.users = {
          wiktorine = {
            # TODO: You can set an initial password for your user.
            # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
            # Be sure to change it (using passwd) after rebooting!
            uid = 1000;
            initialPassword = "correcthorsebatterystaple";
            isNormalUser = true;
            group = "wiktorine";
            extraGroups = [
              "wheel"
              "http"
              "docker"
              "podman"
              "video"
              "uucp"
              "kvm"
              "audio"
              "input"
              "uinput"
            ];
            shell = pkgs.zsh;
            subUidRanges = [
              {
                startUid = 100000;
                count = 65536;
              }
            ];
            subGidRanges = [
              {
                startGid = 100000;
                count = 65536;
              }
            ];
          };
          jasperro = {
            uid = 1002;
            initialPassword = "correcthorsebatterystaple";
            isNormalUser = true;
            group = "wiktorine";
            extraGroups = [
              "wheel"
              "http"
              "docker"
              "podman"
              "video"
              "uucp"
              "kvm"
              "audio"
              "input"
              "uinput"
            ];
            shell = pkgs.zsh;
          };
        };

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "22.11";
      };
  };
}
