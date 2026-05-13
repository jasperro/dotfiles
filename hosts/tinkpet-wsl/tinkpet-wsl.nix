{
  inputs,
  __findFile,
  den,
  ...
}:
{
  den.hosts.x86_64-linux.tinkpet-wsl = {
    description = "Lenovo ThinkPad L15 Gen 2 AMD (WSL configuration).";
    wsl.enable = true;
    users.jasperro = {
      aspect = den.aspects."jasperro@tinkpet-wsl";
      classes = [ "homeManager" ];
    };
    aspect = den.aspects.tinkpet-wsl;
  };

  den.aspects.tinkpet-wsl = {
    includes = [
      <JDF/nixos/audio>
      <JDF/nixos/home-locale>
      <JDF/nixos/nix-alien>
      <JDF/nixos/nix-ld>
      <JDF/nixos/nix>
      <JDF/nixos/sops>
      <JDF/nixos/utilities>

      <JDF/services/podman>
    ];

    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.nixos-wsl.nixosModules.wsl
        ];

        wsl = {
          wslConf.automount.root = "/mnt";
          startMenuLaunchers = true;

          # Enable native Docker support
          # docker-native.enable = true;

          # Enable integration with Docker Desktop (needs to be installed)
          # docker-desktop.enable = true;
        };

        # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "25.05";
      };
  };
}
