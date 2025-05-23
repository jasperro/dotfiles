# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "uas"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8bda6044-be76-44a9-b2d1-967ffe5a2d6b";
    fsType = "btrfs";
    options = [ "subvol=nixosroot" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/8bda6044-be76-44a9-b2d1-967ffe5a2d6b";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/8bda6044-be76-44a9-b2d1-967ffe5a2d6b";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/ACC5-59E5";
    fsType = "vfat";
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
