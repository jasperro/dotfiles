{ pkgs, config, impurity, ... }:

{
  home.packages = with pkgs; [
    #(pkgs.uutils-coreutils.override { prefix = ""; })
    eza
    oh-my-posh
    fish
    zoxide
  ];

  xdg.configFile = {
    "oh-my-posh/config.json".source = impurity.link ./config/oh-my-posh/config.json;
    "nushell/user_config.nu".source = impurity.link ./config/nushell/config.nu;
    "nushell/user_env.nu".source = impurity.link ./config/nushell/env.nu;
  };

  programs = {
    nushell = {
      enable = true;
      configFile = {
        text = ''
          $env.config.show_banner = false
        '';
      };
      extraEnv = ''
        let oh_my_posh_cache = "${config.xdg.cacheHome}/oh-my-posh"
        if not ($oh_my_posh_cache | path exists) {
          mkdir $oh_my_posh_cache
        }
        ${pkgs.oh-my-posh}/bin/oh-my-posh init nu -c ${config.xdg.configHome}/oh-my-posh/config.json --print | save --force ${config.xdg.cacheHome}/oh-my-posh/init.nu
        source ${config.xdg.configHome}/nushell/user_env.nu
      '';
      extraConfig = ''
        source ${config.xdg.cacheHome}/oh-my-posh/init.nu
        source ${config.xdg.configHome}/nushell/user_config.nu
      '';
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        z = "zoxide";
        zi = "zoxide";
        sl = "eza";
        ls = "eza -g";
        l = "eza -l";
        la = "eza -lag";
        ip = "ip --color=auto";
        cp = "cp --reflink=auto --sparse=always";
        rm = "rm -i";
        bgr = "setsid";
        ":q" = "exit";
      };

      autocd = true;
      history.share = true;
      history.ignoreDups = true;

      initExtra = ''
        setopt correct

        bindkey "^[[2~" overwrite-mode
        bindkey "^[OH" beginning-of-line
        bindkey "^[[5~" up-line-or-history
        bindkey "^[[3~" delete-char
        bindkey "^[OF" end-of-line
        bindkey "^[[6~" down-line-or-history
        bindkey "^[OA" history-beginning-search-backward
        bindkey "^[OB" history-beginning-search-forward

        eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh -c ${config.xdg.configHome}/oh-my-posh/config.json)"
      '';

      envExtra = ''
        EDITOR=nvim
        TERM="xterm-256color"
      '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
