{pkgs, ...}: {
  xdg.configFile."nvim/lua" = {
    source = ../configs/nvim/lua;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraConfig = "lua require('init')";

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      cmp-nvim-lua
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-nvim-lsp-document-symbol
      cmp-path
      copilot-cmp
      copilot-lua
      gitsigns-nvim
      indent-blankline-nvim
      leap-nvim
      lsp-format-nvim
      mini-nvim
      neodev-nvim
      neotest
      neotest-elixir
      neotest-rust
      none-ls-nvim
      nvim-cmp
      nvim-dap
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      obsidian-nvim
      rustaceanvim
      telescope-fzf-native-nvim
      telescope-nvim
      trouble-nvim
      vim-tmux-navigator
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      actionlint
      alejandra
      deadnix
      deno
      dotenv-linter
      elixir-ls
      emmet-language-server
      erlang-ls
      lua-language-server
      marksman
      nil
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.vscode-html-languageserver-bin
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      nodejs
      rnix-lsp
      ruff
      ruff-lsp
      rust-analyzer
      rustfmt
      rustywind
      shellcheck
      shfmt
      tailwindcss-language-server
      taplo
      terraform-ls
      tfsec
      tree-sitter
      vscode-langservers-extracted
      zls
    ];
  };
}
