{
  imports = [
    ./minecraft
    ../../common/services/podman.nix
  ];
  systemd.services.disable-usb-wakeup = {
    description = "Disable USB wakeup";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = ''
      echo PTXH > /proc/acpi/wakeup
    '';
    postStop = ''
      echo PTXH > /proc/acpi/wakeup
    '';
    enable = true;
  };
}
