{
  inputs,
  __findFile,
  ...
}:
{
  den.hosts.x86_64-linux.superlaptop = {
    description = "Colin's desktop.";
    users.colin = {
      aspect = "colin-superlaptop";
      classes = [ "homeManager" ];
    };
    aspect = "superlaptop";
  };

  den.aspects.superlaptop = {
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
        key = "superlaptop";
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

        users.groups.colin.gid = 1002;

        users.users = {
          colin = {
            # TODO: You can set an initial password for your user.
            # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
            # Be sure to change it (using passwd) after rebooting!
            uid = 1001;
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
              "colin"
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
      };
  };
}
