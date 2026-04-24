{
  inputs,
  __findFile,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.waffie = {
    description = "Wiktorine low-powered laptop, used for school work.";
    users.wiktorine = {
      aspect = den.aspects.wiktorine-waffie;
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.waffie;
  };

  den.aspects.waffie = {
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
          };
          bluetooth.enable = true;
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

        users.groups.wiktorine.gid = 1003;

        users.users = {
          wiktorine = {
            # TODO: You can set an initial password for your user.
            # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
            # Be sure to change it (using passwd) after rebooting!
            uid = 1000;
            initialPassword = "correcthorsebatterystaple";
            isNormalUser = true;
            extraGroups = [
              "http"
              "docker"
              "i2c"
              "video"
              "uucp"
              "kvm"
              "audio"
              "wheel"
              "wiktorine"
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
        };

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "22.11";
        nixpkgs.hostPlatform = "x86_64-linux";
      };
  };
}
