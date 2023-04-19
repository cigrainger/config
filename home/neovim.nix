{ pkgs, ... }:

let
  elixir-tools-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "elixir-tools.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "elixir-tools";
      repo = "elixir-tools.nvim";
      rev = "8f40d76710d1d43c114c983afedf7fac902a3445";
      hash = "sha256-JZwUvYhMwK7t5wpzfLtTgLYhcOQAx5Z9jdlTzdVKCRE=";
    };
  };
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
      rev = "5bb78ad3c1c11a28a2c48af59056455841e6546f";
      hash = "sha256-b0hJhfIDvcuoDHkj0hVY+xYqYjdTuYyZ1/SljLE9K3M=";
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
      bufferline-nvim
      catppuccin-nvim
      cmp-git
      cmp-nvim-lua
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-nvim-lsp-document-symbol
      cmp-path
      cmp-rg
      cmp_luasnip
      copilot-cmp
      copilot-lua
      crates-nvim
      elixir-tools-nvim
      flit-nvim
      friendly-snippets
      gitsigns-nvim
      leap-nvim
      lualine-nvim
      luasnip
      mini-nvim
      neodev-nvim
      neotest
      neotest-elixir
      neotest-rust
      null-ls-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-surround
      nvim-tree-lua
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      octo-nvim
      rust-tools-nvim
      telescope-fzf-native-nvim
      telescope-nvim
      todo-comments-nvim
      trouble-nvim
      vim-tmux-navigator
      which-key-nvim
      wilder-nvim
    ];

    extraPackages = with pkgs; [
      actionlint
      deadnix
      dotenv-linter
      hadolint
      nodejs
      rnix-lsp
      tfsec
      nodePackages.prettier
      tree-sitter
    ];
  };
}
