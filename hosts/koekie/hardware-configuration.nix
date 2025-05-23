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
    "sr_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b5bce230-29cb-4721-9bd7-85402e65fe70";
    fsType = "btrfs";
    options = [ "subvol=@nixosroot" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/b5bce230-29cb-4721-9bd7-85402e65fe70";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/b5bce230-29cb-4721-9bd7-85402e65fe70";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/735B-75E8";
    fsType = "vfat";
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/b5bce230-29cb-4721-9bd7-85402e65fe70";
    fsType = "btrfs";
    options = [ "subvol=@snapshots" ];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
