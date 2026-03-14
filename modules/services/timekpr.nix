{ pkgs, ... }:
{
  services.timekpr = {
    enable = true;
    adminUsers = [ "jasperro" ];
    # We want to override the default package to change the config file content, to enable playtime features.
    package = pkgs.timekpr.overrideAttrs (prev: {
      postInstall = (prev.postInstall or "") + ''
        sed -i 's/TIMEKPR_PLAYTIME_ENABLED = False/TIMEKPR_PLAYTIME_ENABLED = True/' $out/etc/timekpr/timekpr.conf
        sed -i 's/TIMEKPR_PLAYTIME_ENHANCED_ACTIVITY_MONITOR_ENABLED = False/TIMEKPR_PLAYTIME_ENHANCED_ACTIVITY_MONITOR_ENABLED = True/' $out/etc/timekpr/timekpr.conf
      '';
    });

  };
}
