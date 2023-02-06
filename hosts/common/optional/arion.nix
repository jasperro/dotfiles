{ pkgs, inputs, ... }: {
  imports = [
    inputs.arion.nixosModules.arion
  ];

  environment.systemPackages = with pkgs; [ arion ];

  virtualisation.arion = {
    backend = "podman-socket";
  };
}
