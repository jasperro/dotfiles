{ pkgs, stdenv, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    maps = {
      normal = {
        "x" = "\"_x";
        "X" = "\"_X";
        "d" = "\"_d";
        "D" = "\"_D";
      };
    };

    colorschemes.gruvbox.enable = true;

    clipboard.providers.wl-copy.enable = true;
    clipboard.register = "unnamedplus";

    plugins = {
      lightline.enable = true;
      copilot-vim.enable = true;
      emmet.enable = true;
    };

    plugins.lsp = {
      enable = true;
      servers = {
        astro.enable = true;
        rnix-lsp.enable = true;
        yamlls.enable = true;
        gdscript.enable = true;
        gopls.enable = true;
        hls.enable = true;
        rust-analyzer.enable = true;
        csharp-ls.enable = true;
        kotlin-language-server.enable = true;
        pylsp.enable = true;
        tailwindcss.enable = true;
        texlab.enable = true;
        tsserver.enable = true;

        cssls.enable = true;
        eslint.enable = true;
        html.enable = true;
        jsonls.enable = true;
      };
    };
  };

  home.packages = with pkgs; [
    ripgrep
    gnumake

    texlab

    # Webdev
    nodePackages.svelte-language-server
    nodePackages.stylelint
  ];
}
