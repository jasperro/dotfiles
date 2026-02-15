{
  inputs,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  stylix.targets.noctalia-shell.enable = true;

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    settings = {
      bar = {
        barType = "simple";
        position = "top";
        monitors = [ ];
        density = "default";
        showOutline = false;
        showCapsule = false;
        useSeparateOpacity = false;
        floating = false;
        marginVertical = 4;
        marginHorizontal = 4;
        frameThickness = 8;
        frameRadius = 12;
        outerCorners = true;
        hideOnOverview = false;
        displayMode = "always_visible";
        widgets = {
          left = [
            {
              id = "Launcher";
              icon = "apps";
            }
            {
              id = "Clock";
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "ActiveWindow";
              maxWidth = 550;
            }
          ];
          center = [
            {
              id = "Workspace";
              # pillSize = 0.8;
              showApplications = true;
            }
          ];
          right = [
            {
              id = "MediaMini";
            }
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "KeepAwake";
            }
            {
              id = "ControlCenter";
              useDistroLogo = true;
              colorizeDistroLogo = true;
              enableColorization = true;
            }
          ];
        };
        screenOverrides = [ ];
      };
      dock.enabled = false;
      wallpaper.enabled = false;
      general = {
        radiusRatio = 0.4;
      };
      location = {
        name = "Hooglanderveen, Netherlands";
      };
      network = {
        wifiEnabled = false;
        airplaneModeEnabled = false;
        bluetoothRssiPollingEnabled = false;
        bluetoothHideUnnamedDevices = false;
        disableDiscoverability = true;
      };
      appLauncher = {
        enableClipboardHistory = true;
        autoPasteClipboard = true;
      };
      brightness.enableDdcSupport = true;
      nightLight.enabled = true;
      audio.volumeFeedback = true;
    };
  };
}
