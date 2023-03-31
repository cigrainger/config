{ pkgs, ... }:

let
  neotest-elixir = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "neotest-elixir";
    src = pkgs.fetchFromGitHub {
      owner = "jfpedroza";
      repo = "neotest-elixir";
      rev = "72ead0e41aa88582631ff7a14c13095b87c7ff75";
      hash = "sha256-o7mecEUYnGRomt8qH67rKxHfhGqjoQmAEzwW/TIeQ/s=";
    };
  };
  neotest-rust = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "neotest-rust";
    src = pkgs.fetchFromGitHub {
      owner = "rouge8";
      repo = "neotest-rust";
      rev = "ceb091b6fe30c675564b81a166064fc283eab7ae";
      hash = "sha256-7YM3rt+QLgWsIDO86IoOOTdXzgG4BBp0p2IdO48q0Us=";
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
      catppuccin-nvim
      cmp-git
      cmp-nvim-lua
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
      neodev-nvim
      neotest
      # neotest-elixir
      # neotest-rust
      null-ls-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-notify
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      octo-nvim
      rust-tools-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      todo-comments-nvim
      trouble-nvim
      vim-nix
      vim-repeat
      vim-surround
      vim-tmux-navigator
      which-key-nvim
      wilder-nvim
    ];

    extraPackages = with pkgs; [
      elixir_ls
      hadolint
      lua
      lua-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodejs
      rnix-lsp
      shellcheck
      taplo
      terraform-ls
      tfsec
      tree-sitter
    ];
  };
}
