{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
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
    '';

    envExtra = ''
      EDITOR=nvim
      TERM="xterm-256color"
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./config/p10k-config;
        file = "p10k.zsh";
      }
    ];
  };

  home.packages = with pkgs; [
    #(pkgs.uutils-coreutils.override { prefix = ""; })
    eza
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
