{ pkgs, ... }:

let
  copilot-lua = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "copilot.lua";
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = "copilot.lua";
      rev = "bbb518fbba065773e50bb8e71eae42f7b7f0e2b0";
      hash = "sha256-Lj60vbmZ5BRA8p2NDXSezD0cjP5mCBlRWvt0AbaQXpY=";
    };
  };
  copilot-cmp = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "copilot-cmp";
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = "copilot-cmp";
      rev = "84d5a0e8e4d1638e7554899cb7b642fa24cf463f";
      hash = "sha256-cU3WC5mEYh6pJFZ2ezV01dCq/FTtfAdpvLTRlVAzHqA=";
    };
  };
in
{
  xdg.configFile."nvim/lua" = {
    source = ../configs/nvim/lua;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = "lua require('init')";

    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      catppuccin-nvim
      cmp-git
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-path
      cmp-rg
      cmp_luasnip
      comment-nvim
      copilot-cmp
      copilot-lua
      crates-nvim
      friendly-snippets
      gitsigns-nvim
      leap-nvim
      lualine-nvim
      luasnip
      null-ls-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-notify
      nvim-tree-lua
      nvim-web-devicons
      octo-nvim
      rust-tools-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      todo-comments-nvim
      trouble-nvim
      vim-nix
      vim-tmux-navigator
      vim-repeat
      vim-surround
      which-key-nvim
      wilder-nvim
    ];

    extraPackages = with pkgs; [
      nodePackages.dockerfile-language-server-nodejs
      elixir_ls
      nodejs
      rnix-lsp
      sumneko-lua-language-server
      taplo
      terraform-ls
    ];
  };
}
