{ inputs, jdf, ... }: {
  den.aspects.tosti._.disko-config = {
    includes = [ jdf.system._.disko ];
    nixos = {
      disko.devices = {
        disk = {
          main = {
            type = "disk";
            device = "/dev/disk/by-uuid/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
            content = {
              type = "gpt";
              partitions = {
                ESP = {
                  size = "512M";
                  type = "EF00";
                  content = {
                    type = "filesystem";
                    format = "vfat";
                    mountpoint = "/boot";
                    mountOptions = [ "umask=0077" ];
                  };
                };
                luks = {
                  size = "100%";
                  content = {
                    type = "luks";
                    name = "crypted";
                    # disable settings.keyFile if you want to use interactive password entry
                    passwordFile = "/tmp/secret.key"; # Interactive
                    settings = {
                      allowDiscards = true;
                      # keyFile = "/tmp/secret.key";
                    };
                    additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                    content = {
                      type = "btrfs";
                      extraArgs = [ "-f" ];
                      subvolumes = {
                        "@nixosroot" = {
                          mountpoint = "/";
                          mountOptions = [
                            "noatime"
                            "compress=zstd:3"
                            "ssd"
                          ];
                        };
                        "@home" = {
                          mountpoint = "/home";
                          mountOptions = [
                            "noatime"
                            "compress=zstd:3"
                            "ssd"
                          ];
                        };
                        "@nix" = {
                          mountpoint = "/nix";
                          mountOptions = [
                            "noatime"
                            "compress=zstd:3"
                            "ssd"
                          ];
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
