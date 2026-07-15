{
  jdf,
  den,
  lib,
  ...
}:
{
  jdf.system._.encrypted-btrfs-filesystem = { host }: {
    ${host.class} =
      { config, lib, ... }:
      let
        cfg = host.encrypted-btrfs-filesystem;
        decryptPart = "crypted";
        decryptPath = "/dev/mapper/${decryptPart}";
      in
      {
        assertions = [
          {
            assertion = cfg.partitions.luks != "";
            message = "Please specify a LUKS partition to use as the root filesystem.";
          }
          {
            assertion = cfg.partitions.boot != "";
            message = "Please specify your boot partition.";
          }
        ];

        boot.initrd.luks.devices.${decryptPart} = {
          device = cfg.partitions.luks;
          crypttabExtraOpts = lib.mkIf config.systemd.tpm2.enable [ "tpm2-device=auto" ];
        };

        fileSystems = {
          "/boot" = {
            device = cfg.partitions.boot;
            fsType = "vfat";
            options = [
              "rw"
              "relatime"
              "fmask=0022"
              "dmask=0022"
              "codepage=437"
              "iocharset=iso8859-1"
              "shortname=mixed"
              "utf8"
              "errors=remount-ro"
            ];
          };
          "/" = {
            device = decryptPath;
            fsType = "btrfs";
            options = [
              "subvol=@nixosroot"
              "rw"
              "noatime"
              "compress=zstd:3"
              "ssd"
            ];
          };
          "/home" = {
            device = decryptPath;
            fsType = "btrfs";
            options = [
              "subvol=@home"
              "rw"
              "noatime"
              "compress=zstd:3"
              "ssd"
            ];
          };
          "/nix" = {
            device = decryptPath;
            fsType = "btrfs";
            options = [
              "subvol=@nix"
              "rw"
              "noatime"
              "compress=zstd:3"
              "ssd"
            ];
          };
        };
      };
  };

  den.policies.encrypted-btrfs-filesystem = { host, ... }: [
    (den.lib.policy.include jdf.system._.encrypted-btrfs-filesystem)
  ];

  den.schema.host.includes = [
    (den.lib.policy.when (
      { host, ... }: host.class == "nixos" && host.encrypted-btrfs-filesystem.enable
    ) den.policies.encrypted-btrfs-filesystem)
  ];

  den.schema.host.options.encrypted-btrfs-filesystem = {
    enable = lib.mkEnableOption "standard BTRFS subvolumes and parameters";

    partitions = {
      boot = lib.mkOption {
        type = lib.types.str;
        description = "The ID of your boot partition. Use /dev/disk/by-uuid for best results.";
        default = "";
      };
      luks = lib.mkOption {
        type = lib.types.str;
        description = "The ID of your LUKS partition. Use /dev/disk/by-uuid for best results.";
        default = "";
      };
    };
  };
}
