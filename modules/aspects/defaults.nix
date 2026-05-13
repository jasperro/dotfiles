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
    # Temporary fix, see https://github.com/NixOS/nixpkgs/issues/513245
    nixpkgs.overlays = [
      (final: prev: {
        openldap = prev.openldap.overrideAttrs (_: {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        });
      })
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

      home.stateVersion = "25.05";
    };
}
