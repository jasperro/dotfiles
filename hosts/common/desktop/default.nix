{ pkgs, ... }: {
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

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      iosevka
      dejavu_fonts
      fira-code
      fira-code-symbols
      fira-mono
      fira
      ubuntu_font_family
      source-code-pro
      source-serif-pro
      source-sans-pro
      roboto
      roboto-mono
      jetbrains-mono
      terminus_font
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif = [ "Source Serif Pro" ];
      };
    };
  };
}
