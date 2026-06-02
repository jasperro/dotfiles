{
  lib,
  inputs,
  outputs,
  den,
  __findFile,
  ...
}:
{
  den.schema.hm-host.includes = [
    {
      nixos.home-manager = {
        useGlobalPkgs = true;
        backupFileExtension = "hmbackup";
        extraSpecialArgs = {
          inherit inputs;
          inherit outputs;
        };
      };
    }
  ];

  den.default.includes = [
    <impurity>
  ];

  den.schema.user.includes = [
    den._.mutual-provider
  ];

  den.default.nixos = {
    nixpkgs.overlays = [
    ];
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

      home.stateVersion = "26.05";
    };
}
