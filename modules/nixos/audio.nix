{
  JDF.nixos._.audio.nixos = {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # store amount of channels, etc (2ch or 6ch depending on surround/headphones)
    hardware.alsa.enablePersistence = true;
  };
}
