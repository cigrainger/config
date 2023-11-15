{ pkgs, ... }:

let
  elixir-tools-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "elixir-tools.nvim";
    version = "2023-11-08";
    src = pkgs.fetchFromGitHub {
      owner = "elixir-tools";
      repo = "elixir-tools.nvim";
      rev = "51399bc41e9a70b8920fcd5869eb2a3628e8facc";
      sha256 = "sha256-AZV6bkLu2Q92pIiDh83JGL7Tue1G9bMSCCQ3Gvl/2vQ=";
    };
    meta.homepage = "https://github.com/elixir-tools/elixir-tools.nvim/";
  };
  workspace-folders-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "workspace-folders.nvim";
    version = "2023-11-08";
    src = pkgs.fetchFromGitHub {
      owner = "mhanberg";
      repo = "workspace-folders.nvim";
      rev = "2edb25739ab06a60135bf6380bc8f96325772a6f";
      sha256 = "sha256-MPz/Y1hPc2T3NfLSaVd+xyr1FW4zF8e1b5LHlP37W1E=";
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
      aerial-nvim
      bufferline-nvim
      catppuccin-nvim
      ChatGPT-nvim
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
      fidget-nvim
      flash-nvim
      friendly-snippets
      gitsigns-nvim
      lspkind-nvim
      lualine-nvim
      luasnip
      mini-nvim
      neodev-nvim
      neotest
      neotest-elixir
      neotest-rust
      none-ls-nvim
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
      workspace-folders-nvim
    ];

    extraPackages = with pkgs; [
      actionlint
      deadnix
      dotenv-linter
      nodejs
      rnix-lsp
      tfsec
      nodePackages.prettier
      tree-sitter
    ];
  };
}
