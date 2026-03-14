{
  JDF.nixos._.gui.nixos =
    { pkgs, ... }:
    {
      # Enable CUPS to print documents.
      services.printing.enable = true;

      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          noto-fonts-emoji-blob-bin

          liberation_ttf
          dejavu_fonts

          fira-code
          fira-code-symbols
          fira-mono
          fira

          adwaita-fonts

          ubuntu-sans
          ubuntu-sans-mono

          source-code-pro
          source-serif-pro
          source-sans-pro

          roboto
          roboto-mono

          jetbrains-mono
          iosevka

          nerd-fonts.symbols-only
        ];
        fontconfig = {
          antialias = true;
          cache32Bit = true;
          hinting.enable = true;
          hinting.autohint = true;
          defaultFonts = {
            monospace = [
              "Source Code Pro"
              "Symbols Nerd Font Mono"
            ];
            sansSerif = [ "Source Sans Pro" ];
            serif = [ "Source Serif Pro" ];
            emoji = [
              "Blobmoji"
              "Noto Color Emoji"
            ];
          };
          useEmbeddedBitmaps = true;
        };
      };
    };
}
