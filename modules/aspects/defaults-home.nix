{
  inputs,
  outputs,
  lib,
  ...
}:
{
  den.default.nixos = {
    home-manager.useGlobalPkgs = true;
    home-manager.backupFileExtension = "hmbackup";
    home-manager.extraSpecialArgs = {
      inherit inputs;
      inherit outputs;
    };
  };
  den.default.homeManager =
    { pkgs, ... }:
    {
      nix.enable = lib.mkDefault false;

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-qt;
      };

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      home.stateVersion = "25.05";
    };
}
