{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = ",";

    keymaps = [
      {
        mode = "n";
        key = "x";
        action = "\"_x";
      }
      {
        mode = "n";
        key = "X";
        action = "\"_X";
      }
      {
        mode = "n";
        key = "d";
        action = "\"_d";
      }
      {
        mode = "n";
        key = "D";
        action = "\"_D";
      }
      {
        mode = "n";
        key = "<leader>x";
        action = "x";
      }
      {
        mode = "n";
        key = "<leader>X";
        action = "X";
      }
      {
        mode = "n";
        key = "<leader>d";
        action = "d";
      }
      {
        mode = "n";
        key = "<leader>D";
        action = "D";
      }
    ];

    clipboard.providers.wl-copy.enable = true;
    clipboard.register = "unnamedplus";

    plugins = {
      lualine = {
        enable = true;
        settings.options.theme = "base16";
      };
      emmet.enable = true;
    };

    plugins.lsp = {
      enable = true;
      servers = {
        # astro.enable = true;
        nixd.enable = true;
        yamlls.enable = true;
        # gdscript.enable = true;
        # gopls.enable = true;
        # hls.enable = true;
        # rust_analyzer = {
        #   enable = true;
        #   installCargo = true;
        #   installRustc = true;
        # };
        # csharp-ls.enable = true;
        # kotlin-language-server.enable = true;
        # pylsp.enable = true;
        # tailwindcss.enable = true;
        # texlab.enable = true;
        # tsserver.enable = true;

        # cssls.enable = true;
        # eslint.enable = true;
        # html.enable = true;
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
