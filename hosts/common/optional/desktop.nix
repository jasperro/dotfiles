{
  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire =
    {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  xdg.portal.enable = true;
}
