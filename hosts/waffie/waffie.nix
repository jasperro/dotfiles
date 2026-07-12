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
      aspect = den.aspects."wiktorine@waffie";
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.waffie;
  };

  den.aspects.waffie = {
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

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "22.11";
      };
  };
}
