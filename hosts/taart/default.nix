# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{
  inputs,
  outputs,
  pkgs,
  impurity,
  # modulesPath,
  ...
}:
{
  imports = [
    # "${modulesPath}/virtualisation/lxc-container.nix"
    inputs.home-manager.nixosModules.home-manager
    ./services
    ../common/nixos
    ../common/nixos/home-locale.nix

    # Disable all below for LXC
    # inputs.hardware.nixosModules.raspberry-pi-4
    # inputs.hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix
    ./networking.nix
  ];

  # For LXC/systemd-nspawn
  # networking.useHostResolvConf = false;
  # networking.dhcpcd.enable = lib.mkForce false;

  # boot = {
  #   # tmp.useTmpfs = true;
  #   # LXC Stuff
  #   isContainer = true;
  #   loader.generic-extlinux-compatible.enable = false;
  # };
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
  };

  boot.initrd.systemd.enable = true;

  hardware = {
    # raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    # deviceTree = {
    #   enable = true;
    #   filter = "*rpi-4-*.dtb";
    # };
    enableRedistributableFirmware = true;
  };

  # deviceTree stuff from https://git.eisfunke.com/config/nixos/-/blob/main/devices/amethyst.nix
  # Thanks @eisfunke for figuring this stuff out!
  hardware.deviceTree =
    let
      /*
        Pin the raspberrypifw package to an old version.

        - later versions bricked the devicetree so that HDMI wouldn't work anymore
        - due to some changes around HDMI and audio for the rpi5?
        - see: https://github.com/pftf/RPi4/issues/252
        - the uefi firmware rolled back to a version of the raspberrypi/firmware repo before those
          changes: https://github.com/pftf/RPi4/commit/6ba22a07bf19422c199dd801d3442319c04f5090
        - they pinned it to b49983637106e5fb33e2ae60d8c15a53187541e4, so I'm doing the same on the
          system level
      */
      raspberrypifw = pkgs.raspberrypifw.overrideAttrs {
        version = "pinned-2023.05.12";
        src = pkgs.fetchFromGitHub {
          owner = "raspberrypi";
          repo = "firmware";
          rev = "b49983637106e5fb33e2ae60d8c15a53187541e4";
          hash = "sha256-Ia+pUTl5MlFoYT4TrdAry0DsoBrs13rfTYx2vaxoKMw=";
        };
      };
    in
    {
      enable = true;

      # use the devicetree files from the official raspberrypi linux tree
      dtbSource = pkgs.device-tree_rpi.override { inherit raspberrypifw; };
      filter = "bcm2711-rpi-4-b.dtb"; # only apply overlays on the one devicetree I actually need
      name = "broadcom/bcm2711-rpi-4-b.dtb"; # use and load the correct rpi4b devicetree

      /*
        Devicetree overlays applied to the main devicetree.

        - these are applied during build, i.e. these are *not* passed separately to the bootloader
        - they're compiled in beforehand, the resulting single dtb file is then given to the bootloader
        - overlays are applied in the order they're in the list
        - the upstream overlays by raspberrypi are in the raspberrypifw package, see `upstreamOverlay`
        - these are documented in their repo: https://github.com/raspberrypi/linux/blob/rpi-6.6.y/arch/arm/boot/dts/overlays/README

        See:
        - https://docs.zephyrproject.org/latest/build/dts/intro-syntax-structure.html
        - https://bootlin.com/blog/enabling-new-hardware-on-raspberry-pi-with-device-tree-overlays/
        - https://elinux.org/Device_Tree_Source_Undocumented (for `/delete-property/`)
      */
      overlays =
        let
          upstreamOverlay = name: raspberrypifw + /share/raspberrypi/boot/overlays/${name}.dtbo;
        in
        [

          /*
            Fixes a bug I experienced with the mainline kernel where only one CPU core would work.

            - I wrote this overlay to apply the changes from this patch I found online:
              https://github.com/AntonioND/rpi3-arm-tf-bootstrap/blob/master/0001-rpi3-Enable-PSCI-support.patch
            - there'd be "failed to come online" messages in `dmesg`
            - I found the patch here: https://github.com/OP-TEE/build/issues/360
          */
          {
            name = "custom-enable-method";
            dtsText = ''
              /dts-v1/;
              /plugin/;

              / {
                compatible = "brcm,bcm2711";

                fragment@0 {
                  target = <&cpus>;
                  __overlay__ {
                    /delete-property/ enable-method;
                  };
                };

                fragment@1 {
                  target-path = "/";
                  __overlay__ {
                    psci {
                      compatible = "arm,psci-1.0", "arm,psci-0.2";
                      method = "smc";
                    };
                  };
                };

                fragment@2 {
                  target = <&cpu0>;
                  __overlay__ {
                    enable-method = "psci";
                    /delete-property/ cpu-release-addr;
                  };
                };

                fragment@3 {
                  target = <&cpu1>;
                  __overlay__ {
                    enable-method = "psci";
                    /delete-property/ cpu-release-addr;
                  };
                };

                fragment@4 {
                  target = <&cpu2>;
                  __overlay__ {
                    enable-method = "psci";
                    /delete-property/ cpu-release-addr;
                  };
                };

                fragment@5 {
                  target = <&cpu3>;
                  __overlay__ {
                    enable-method = "psci";
                    /delete-property/ cpu-release-addr;
                  };
                };

              };
            '';
          }

          /*
            This overlay comprises the vc4-kms-v3d-pi4 and dwc2 overlays for graphics and USB.

            - note that nixos-hardware uses the vc4-fkms-v3d-pi4 overlay instead
            - fkms (fake/firmware kernel mode setting) uses a feature in the firmware blob, proper kms
              implements mode setting itself
            - https://forums.raspberrypi.com/viewtopic.php?t=255478
            - the kms driver is newer, fkms is deprecated by upstream now
            - fkms didn't work for me anyway
            - kms does, but only with the pinned devicetree repo (see above)
          */
          {
            name = "upstream-pi4";
            dtboFile = upstreamOverlay "upstream-pi4";
          }

        ];
    };

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit inputs outputs impurity; };
  home-manager.backupFileExtension = "hmbackup";

  sops.age.sshKeyPaths = [ "/home/jasperro/.ssh/id_ed25519" ];

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    priority = 10;
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  users.groups.jasperro.gid = 1000;

  home-manager.users.jasperro = import ../../home/jasperro/taart;

  users.users = {
    jasperro = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      uid = 1000;
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = [
        "http"
        "i2c"
        "users"
        "video"
        "uucp"
        "kvm"
        "audio"
        "wheel"
        "jasperro"
      ];
      shell = pkgs.zsh;
      openssh = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOPkTvmcxZ7h5afV6wOt96LUL5SjfLuvi0LSPGmOy4Gq jasperro@doosje"
        ];
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
