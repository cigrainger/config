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
      barbecue-nvim
      catppuccin-nvim
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-nvim-lsp-signature-help
      cmp-nvim-lua
      cmp-path
      cmp-vsnip
      conform-nvim
      copilot-cmp
      copilot-lua
      elixir-tools-nvim
      flash-nvim
      friendly-snippets
      gitsigns-nvim
      indent-blankline-nvim
      mini-nvim
      neo-tree-nvim
      neodev-nvim
      neotest
      neotest-elixir
      neotest-rust
      none-ls-nvim
      nvim-cmp
      nvim-dap
      nvim-lint
      nvim-lspconfig
      nvim-spectre
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      oil-nvim
      rustaceanvim
      telescope-fzf-native-nvim
      telescope-nvim
      trouble-nvim
      vim-caddyfile
      vim-just
      vim-tmux-navigator
      vim-vsnip
      which-key-nvim
    ];

    extraPackages = with pkgs; [
      actionlint
      alejandra
      deadnix
      deno
      djhtml
      dotenv-linter
      elixir-ls
      emmet-language-server
      erlang-ls
      eslint_d
      golangci-lint
      golangci-lint-langserver
      hadolint
      lemminx
      lua-language-server
      marksman
      nil
      nodePackages.bash-language-server
      nodePackages.cspell
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      nodejs
      ruff
      ruff-lsp
      rust-analyzer
      rustfmt
      rustywind
      shellcheck
      shfmt
      sqlfluff
      statix
      stylelint
      stylua
      tailwindcss-language-server
      taplo
      terraform-ls
      tflint
      tree-sitter
      trivy
      vale
      vscode-langservers-extracted
      xmlformat
      yamlfmt
      yamllint
    ];
  };
}
