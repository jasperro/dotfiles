{
  pkgs,
  ...
}:
let
  port = 8888;
in
{
  systemd.services.ledfx = {
    description = "LedFX Audio Reactive LED Controller";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.ledfx ];

    serviceConfig = {
      ExecStart = "${pkgs.ledfx}/bin/ledfx --host 0.0.0.0 --port ${toString port}";
      DynamicUser = true;
      User = "ledfx";
      Group = "ledfx";
      WorkingDirectory = "/var/lib/ledfx"; # safe to write because it's StateDirectory
      StateDirectory = "ledfx"; # creates /var/lib/ledfx owned by dynamic user
      StateDirectoryMode = "0750";
      Restart = "on-failure";
      RuntimeDirectory = "ledfx";
      RuntimeDirectoryMode = "0750";

      # Hardening
      CapabilityBoundingSet = "";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      DevicePolicy = "closed";
      #NoNewPrivileges = true; # Implied by DynamicUser
      PrivateUsers = true;
      #PrivateTmp = true; # Implied by DynamicUser
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = false; # breaks bwrap
      ProtectKernelLogs = false; # breaks bwrap
      ProtectKernelModules = true;
      ProtectKernelTunables = false; # breaks bwrap
      ProtectProc = "invisible";
      ProcSubset = "all"; # Using "pid" breaks bwrap
      ProtectSystem = "strict";
      #RemoveIPC = true; # Implied by DynamicUser
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_NETLINK"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      #RestrictSUIDSGID = true; # Implied by DynamicUser
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
      ];
      UMask = "0077";
    };
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
