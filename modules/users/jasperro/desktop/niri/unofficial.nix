{
  JDF.users._.jasperro._.desktop._.niri._.unofficial.homeManager = {
    wayland.windowManager.niri.settings = {
      layout = {
        blur = {
          on = [ ];
          passes = 3;
          radius = 6.0;
          noise = 0.05;
        };
      };
      window-rule = [
        {
          blur.on = [ ];
        }
      ];
      layer-rule = [
        {
          _children = [
            {
              match._props = {
                namespace = "noctalia-background-.*$";
              };
            }
          ];
          blur = {
            on = [ ];
            x-ray = false;
            ignore-alpha = 0.5;
          };
        }
      ];
    };
  };
}
