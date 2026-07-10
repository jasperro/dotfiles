{
  JDF.users._.jasperro._.desktop._.niri._.blur.homeManager = {
    key = "jasperro-niri-blur";
    wayland.windowManager.niri.settings = {
      blur = {
        on = [ ];
        passes = 3;
        offset = 3;
        noise = 0.05;
      };
      window-rule = [
        {
          background-effect = {
            blur = true;
            xray = false;
            noise = 0.10;
          };
        }
      ];
      layer-rule = [
        {
          _children = [
            {
              match._props = {
                namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
              };
            }
          ];
          background-effect = {
            # blur = false;
            # noise = 0.05;
            xray = false;
          };
        }
      ];
    };
  };
}
