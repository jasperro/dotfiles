{
  __findFile,
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
      <JDF/nixos/home-locale>
      <JDF/nixos/networking>
      <JDF/nixos/nix>
      <JDF/nixos/sops>
      <JDF/nixos/utilities>

      <JDF/services/openssh-inbound>

      <JDF/hosts/taart/services/acme>
      <JDF/hosts/taart/services/nginx>
      <JDF/hosts/taart/services/vaultwarden>
      <JDF/hosts/taart/services/podman>

      <JDF/hosts/taart/services/database/postgresql>

      <JDF/hosts/taart/services/home-automation/mosquitto>
      <JDF/hosts/taart/services/home-automation/zigbee2mqtt>
      <JDF/hosts/taart/services/home-automation/homeassistant>
      <JDF/hosts/taart/services/home-automation/esphome>
      <JDF/hosts/taart/services/home-automation/appdaemon>
      <JDF/hosts/taart/services/home-automation/matterbridge>
      <JDF/hosts/taart/services/home-automation/grott>
    ];

    nixos =
      { pkgs, ... }:
      {
        key = "taart";
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
