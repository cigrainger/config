{
  pkgs,
  config,
  ...
}: let
  local_elixir = pkgs.beam.packages.erlangR26.elixir_1_16;
in {
  home.packages = with pkgs; [
    aws-vault
    awscli2
    cmake
    coreutils
    curl
    du-dust
    duf
    entr
    erlang_26
    fd
    flyctl
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    go
    gcc
    gleam
    glow
    jaq
    jq
    lazydocker
    local_elixir
    minio-client
    mosh
    ncurses
    ollama
    onefetch
    openai
    ripgrep
    rye
    sd
    semgrep
    signal-cli
    tailscale
    tealdeer
    tig
    tree
    unzip
    wget
    wireguard-tools
    xh
    xplr
    xsv
    yubikey-manager
  ];

  programs = {
    gh = {enable = true;};
    bat = {
      enable = true;
      config = {theme = "catppuccin";};
      themes = {
        catppuccin = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat"; # Bat uses sublime syntax for its themes
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          };
          file = "Catppuccin-mocha.tmTheme";
        };
      };
    };

    bottom = {
      enable = true;
      settings = {
        colors = {
          table_header_color = "#f5e0dc";
          all_cpu_color = "#f5e0dc";
          avg_cpu_color = "#eba0ac";
          cpu_core_colors = ["#f38ba8" "#fab387" "#f9e2af" "#a6e3a1" "#74c7ec" "#cba6f7"];
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
          gpu_core_colors = ["#74c7ec" "#cba6f7" "#f38ba8" "#fab387" "#f9e2af" "#a6e3a1"];
          arc_color = "#89dceb";
        };
      };
    };

    broot = {
      enable = true;
      settings = {modal = true;};
    };

    eza.enable = true;

    nushell = {
      enable = true;
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        ulimit -n 10240

        if test -x brew
          eval $(/opt/homebrew/bin/brew shellenv)
        end

        set -gx AWS_VAULT_PROMPT "ykman";
        set -gx ERL_AFLAGS "-kernel shell_history_enabled";
        set -gx FZF_DEFAULT_OPTS " \
          --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
          --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
          --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

        if test -f /Users/chris/.config/op/plugins.sh
          source /Users/chris/.config/op/plugins.sh
        end
      '';
      plugins = [
        {
          name = "fasd";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "fish";
            rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
            sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
          };
        }
      ];
      shellAliases = {
        cat = "bat";
        ls = "exa --icons --color=auto";
        ll = "exa -lah --icons";
        ave = "aws-vault exec";
        avl = "aws-vault login";
        vim = "nvim";
      };
      shellInit = ''
        fish_add_path /opts/homebrew/bin
        fish_add_path /Users/chris/.cargo/bin
        set fish_greeting
      '';
    };

    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = ["--preview 'bat {}'"];
    };

    git = {
      enable = true;
      delta = {
        enable = true;
        options = {side-by-side = true;};
      };
      ignores = [
        ".nix-mix"
        ".nix-hex"
        ".direnv"
        "shell.nix"
        ".envrc"
        ".vscode"
        ".code-workspace"
      ];
      lfs.enable = true;
      userEmail = "chris@amplified.ai";
      userName = "Christopher Grainger";
      extraConfig = {
        init = {defaultBranch = "main";};
        github = {user = "cigrainger";};
        core = {editor = "nvim";};
      };
    };

    gpg = {
      enable = true;
      homedir = "${config.home.homeDirectory}/.gnupg";
      scdaemonSettings = {disable-ccid = true;};
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
            command = "tig blame {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
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
            command = "tig {{.SelectedSubCommit.Sha}} -- {{.SelectedCommitFile.Name}}";
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
          activeBorderColor = ["#a6e3a1" "bold"];
          inactiveBorderColor = ["#cdd6f4"];
          optionsTextColor = ["#89b4fa"];
          selectedLineBgColor = ["#313244"];
          selectedRangeBgColor = ["#313244"];
          cherryPickedCommitBgColor = ["#94e2d5"];
          cherryPickedCommitFgColor = ["#89b4fa"];
          unstagedChangesColor = ["red"];
        };
      };
    };

    navi.enable = true;

    nnn = {
      enable = true;
      extraPackages = with pkgs; [ffmpegthumbnailer mediainfo];
      package = pkgs.nnn.override {withNerdIcons = true;};
    };

    starship = {
      enable = true;
      settings =
        {
          format = "$all"; # Remove this line to disable the default prompt format
          palette = "catppuccin_mocha";
        }
        // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "catppuccin";
            repo = "starship";
            rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
            sha256 = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
          }
          + /palettes/mocha.toml));
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      mouse = true;
      terminal = "tmux-256color";
      extraConfig = ''
        set -sg escape-time 0
        set-option -g history-limit 10000
        set-option -ga terminal-overrides ',xterm-256color:Tc'
        set -as terminal-overrides ',vte*:Smulx=\E[4\:%p1%dm'
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      '';
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_window_right_separator "█ "
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_window_middle_separator " | "

            set -g @catppuccin_window_default_fill "none"

            set -g @catppuccin_window_current_fill "all"

            set -g @catppuccin_status_modules_right "application session user host date_time"
            set -g @catppuccin_status_left_separator "█"
            set -g @catppuccin_status_right_separator "█"

            set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M:%S"
          '';
        }
        fuzzback
        vim-tmux-navigator
        yank
      ];
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        return {
          font = wezterm.font("Berkeley Mono"),
          font_size = 12.0,
          color_scheme = "Catppuccin Mocha",
          hide_tab_bar_if_only_one_tab = true,
        }
      '';
    };

    zoxide.enable = true;
  };

  xdg.configFile."fish/themes" = {
    source = ./configs/fish/themes;
    recursive = true;
  };
}
