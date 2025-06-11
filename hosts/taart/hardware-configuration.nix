{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.kernelModules = [
      "zstd"
      "btrfs"
    ];
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "uas"
      "pcie_brcmstb"
      "reset-raspberrypi"
    ];
    # kernelParams = [
    #   "console=ttyS0,115200n8"
    #   "console=ttyAMA0,115200n8"
    #   "console=tty0"
    #   "root=/dev/disk/by-label/RASPIROOT"
    #   "rootfstype=btrfs"
    #   "rootflags=subvol=@nixosroot"
    #   "rootwait"
    # ];
  };

  fileSystems =
    let
      opts = [
        "noatime"
        "ssd"
        "autodefrag"
        "discard=async"
        "compress=zstd:3"
      ];
      fsType = "btrfs";
      device = "/dev/disk/by-label/RASPIROOT";
    in
    {
      "/" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@nixosroot" ];
      };
      "/nix" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@nix" ];
      };
      "/var" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@var" ];
      };
      "/home" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@home" ];
      };
      "/.snapshots" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@snapshots" ];
      };
      "/boot" = {
        device = "/dev/disk/by-label/RASPIFIRM";
        fsType = "vfat";
        options = [
          "nofail"
          "noauto"
        ];
      };
    };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "aarch64-linux";
}
