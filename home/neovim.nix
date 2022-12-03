{ pkgs, ... }:

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
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      comment-nvim
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
      nvim-treesitter-textobjects
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
      elixir_ls
      rnix-lsp
      sumneko-lua-language-server
      terraform-ls
    ];
  };
}
