{ __findFile, ... }:
{
  den.aspects.colin-superlaptop = {
    homeManager =
      { pkgs, ... }:
      {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          matchBlocks."*" = {
            userKnownHostsFile = "~/.ssh/known_hosts ~/.ssh/known_host_github";
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
        };
        # Add github to known ssh hosts
        home.file.".ssh/known_host_github" = {
          text = ''
            github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
          '';
          force = true;
        };

        programs.git = {
          enable = true;
          settings = {
            user = {
              name = "Colin Albering";
              email = "colin@albering.nl";
            };
            pull.rebase = true;
            checkout.defaultremote = "origin";
            init.defaultbranch = "main";
            core.autocrlf = "input";
          };
        };

        home.packages = with pkgs; [
          kdePackages.kdeconnect-kde
          # general desktop apps
          vscode
          firefox
          #firefox-devedition-bin
          arduino
          alacritty
          #teams
          gimp3
          discord
          inkscape
          qalculate-qt
          kdePackages.ark
          cool-retro-term
          obs-studio

          # Office
          libreoffice
          hyphen
          hunspell
          hunspellDicts.en_US
          hunspellDicts.nl_nl

          # X/Wayland utilities
          x11_ssh_askpass
          xeyes
          wl-clipboard
          wl-clipboard-x11
          waypipe
          waynergy
          wev

          dconf
          dconf-editor
          gparted

          # wine
          wine-wayland
          winetricks

          # multimedia
          pwvucontrol
          vlc

          # games
          lutris
          steam
          prismlauncher

          # LaTeX
          # texlive.combined.scheme-medium
        ];
      };
  };
}
