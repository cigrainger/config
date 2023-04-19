{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    aws-vault
    cargo
    coreutils
    curl
    dog
    du-dust
    duf
    beam.packages.erlangR25.elixir_1_14
    erlangR25
    erlang-ls
    elixir_ls
    entr
    fd
    gcc
    gh
    glow
    jq
    lazydocker
    lua
    lua-language-server
    mosh
    ncurses
    nil
    nixfmt
    nixpkgs-fmt
    nodePackages."@tailwindcss/language-server"
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vscode-json-languageserver
    nodePackages.typescript-language-server
    nodePackages.yaml-language-server
    onefetch
    ripgrep
    rust-analyzer
    rustfmt
    rustc
    sd
    shellcheck
    shfmt
    signal-cli
    taplo
    taskwarrior
    taskwarrior-tui
    tealdeer
    terraform-ls
    tig
    tree
    unzip
    wget
    xh
    xplr
    xsv
    wireguard-tools
    yubikey-manager
    zls
  ];

  programs = {
    bottom = {
      enable = true;
      settings = {
        colors = {
          table_header_color = "#f5e0dc";
          all_cpu_color = "#f5e0dc";
          avg_cpu_color = "#eba0ac";
          cpu_core_colors = [ "#f38ba8" "#fab387" "#f9e2af" "#a6e3a1" "#74c7ec" "#cba6f7" ];
          ram_color = "#a6e3a1";
          swap_color = "#fab387";
          rx_color = "#a6e3a1";
          tx_color = "#f38ba8";
          widget_title_color = "#f2cdcd";
          border_color = "#585b70";
          highlighted_border_color = "#f5c2e7";
          text_color = "#cdd6f4";
          graph_color = "#a6adc8";
          cursor_color = "#f5c2e7";
          selected_text_color = "#11111b";
          selected_bg_color = "#cba6f7";
          high_battery_color = "#a6e3a1";
          medium_battery_color = "#f9e2af";
          low_battery_color = "#f38ba8";
          gpu_core_colors = [ "#74c7ec" "#cba6f7" "#f38ba8" "#fab387" "#f9e2af" "#a6e3a1" ];
          arc_color = "#89dceb";
        };
      };
    };

    navi.enable = true;

    exa = { enable = true; };

    zoxide.enable = true;

    helix = {
      enable = true;
      settings = {
        theme = "kanagawa";
        editor = {
          soft-wrap.enable = true;
          lsp.display-messages = true;
          indent-guides.render = true;
        };
        keys.normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          space.H = ":toggle lsp.display-inlay-hints";
        };
      };
      languages = [
        {
          formatter = { command = "nixpkgs-fmt"; };
          auto-format = true;
          name = "nix";
        }
        {
          name = "elixir";
          auto-format = true;
          config = { elixirLS.dialyzer_enabled = true; };
        }
      ];
    };

    bat = {
      enable = true;
      config = { theme = "catppuccin"; };
      themes = {
        catppuccin = builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "bat"; # Bat uses sublime syntax for its themes
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          } + "/Catppuccin-mocha.tmTheme");
      };
    };

    lazygit = {
      enable = true;
      settings = {
        customCommands = [
          {
            key = "b";
            command = "tig blame -- {{.SelectedFile.Name}}";
            context = "files";
            description = "blame file at tree";
            subprocess = true;
          }
          {
            key = "b";
            command =
              "tig blame {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
            context = "commitFiles";
            description = "blame file at revision";
            subprocess = true;
          }
          {
            key = "B";
            command = "tig blame -- {{.SelectedCommitFile.Name}}";
            context = "commitFiles";
            description = "blame file at tree";
            subprocess = true;
          }
          {
            key = "t";
            command = "tig -- {{.SelectedFile.Name}}";
            context = "files";
            description = "tig file (history of commits affecting file)";
            subprocess = true;
          }
          {
            key = "t";
            command =
              "tig {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
            context = "commitFiles";
            description = "tig file (history of commits affecting file)";
            subprocess = true;
          }
          {
            key = "<c-r>";
            command = "gh pr create --fill --web";
            context = "global";
            description = "create pull request";
            subprocess = true;
            loadingText = "Creating pull request on GitHub";
          }
        ];
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
        gui.theme = {
          lightTheme = false;
          activeBorderColor = [ "#a6e3a1" "bold" ];
          inactiveBorderColor = [ "#cdd6f4" ];
          optionsTextColor = [ "#89b4fa" ];
          selectedLineBgColor = [ "#313244" ];
          selectedRangeBgColor = [ "#313244" ];
          cherryPickedCommitBgColor = [ "#94e2d5" ];
          cherryPickedCommitFgColor = [ "#89b4fa" ];
          unstagedChangesColor = [ "red" ];
        };
      };
    };

    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          syntax-theme = "Dracula";
          side-by-side = true;
        };
      };
      ignores = [ ".nix-mix" ".nix-hex" ".direnv" "shell.nix" ".envrc" ".vscode" ];
      lfs.enable = true;
      userEmail = "chris@amplified.ai";
      userName = "Christopher Grainger";
      extraConfig = {
        github = { user = "cigrainger"; };
        core = { editor = "nvim"; };
        url = { "https://github.com" = { insteadOf = "git://github.com/"; }; };
      };
      signing = {
        key = "2DAADC742D1B5395";
        signByDefault = true;
      };
    };

    gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.gnupg";
      scdaemonSettings = { disable-ccid = true; };
    };
  };
}
