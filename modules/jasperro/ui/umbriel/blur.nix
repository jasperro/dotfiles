{
  jdfPath,
  lib,
  ...
}:
{
  jdf = lib.setAttrByPath jdfPath {
    homeManager = {
      programs.umbriel.settings = {
        appearance.blur = {
          enabled = true;
          optimized = false;
          passes = 3;
          radius = 3;
          noise = 0.05;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.1;
        };

        window_rule = [
          {
            blur = true;
            blur_ignore_alpha = 0.5;
            blur_popups = true;
          }
        ];

        layer_rule = [
          {
            match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
            blur = true;
            blur_ignore_alpha = 0.5;
            blur_popups = true;
          }
        ];
      };
    };
  };
}
