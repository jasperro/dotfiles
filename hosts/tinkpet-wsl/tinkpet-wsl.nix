{
  inputs,
  jdf,
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
      # jdf.system._.audio
      jdf.system._.home-locale
      jdf.system._.nix-alien
      jdf.system._.nix-ld
      jdf.system._.nix
      jdf.system._.sops
      jdf.system._.utilities

      jdf.services._.podman
    ];

    nixos =
      { pkgs, ... }:
      {
        imports = [
          inputs.nixos-wsl.nixosModules.wsl
        ];

        programs.dconf.enable = true;

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
