{ pkgs, ... }: {
  imports = [
    ../../../common/optional/arion.nix
  ];
  virtualisation.arion.projects.home-assistant.settings = import ./arion-compose.nix;
}
