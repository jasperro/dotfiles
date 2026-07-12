{
  jdf,
  den,
  ...
}:
{
  den.hosts.aarch64-linux.taart = {
    description = "Raspberry Pi 4, used for various home server tasks.";
    aspect = den.aspects.taart;
    users.jasperro = {
      aspect = den.aspects."jasperro@taart";
      classes = [ "homeManager" ];
    };
  };

  den.aspects.taart = {
    includes = [
      jdf.system._.home-locale
      jdf.system._.networking
      jdf.system._.nix
      jdf.system._.sops
      jdf.system._.utilities

      jdf.services._.openssh-inbound

      jdf.hosts._.taart._.services._.acme
      jdf.hosts._.taart._.services._.nginx
      jdf.hosts._.taart._.services._.vaultwarden
      jdf.hosts._.taart._.services._.podman

      jdf.hosts._.taart._.services._.database._.postgresql

      jdf.hosts._.taart._.services._.home-automation._.mosquitto
      jdf.hosts._.taart._.services._.home-automation._.zigbee2mqtt
      jdf.hosts._.taart._.services._.home-automation._.homeassistant
      jdf.hosts._.taart._.services._.home-automation._.esphome
      jdf.hosts._.taart._.services._.home-automation._.appdaemon
      jdf.hosts._.taart._.services._.home-automation._.matterbridge
      jdf.hosts._.taart._.services._.home-automation._.grott
    ];

    nixos =
      { pkgs, ... }:
      {
        imports = [
          # Disable all below for LXC
          # inputs.hardware.nixosModules.raspberry-pi-4
          # inputs.hardware.nixosModules.common-pc-ssd
          ./_hardware-configuration.nix
          ./_firmware.nix
        ];

        boot = {
          # tmp.useTmpfs = true;
          kernelPackages = pkgs.linuxPackages_latest;
          loader = {
            systemd-boot = {
              enable = true;
              configurationLimit = 6;
              consoleMode = "max";
            };
            efi.canTouchEfiVariables = true;
          };
          initrd.systemd.enable = true;
        };

        sops.age.sshKeyPaths = [ "/home/jasperro/.ssh/id_ed25519" ];

        zramSwap = {
          enable = true;
          memoryPercent = 40;
          priority = 10;
        };

        environment.systemPackages = with pkgs; [
          libraspberrypi
        ];

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "25.05";
      };
  };
}
