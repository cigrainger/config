{
  pkgs,
  config,
  ...
}: let
  local_elixir = pkgs.beam.packages.erlang_27.elixir_1_17;
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
    erlang_27
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
    sad
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
    yt-dlp
    yubikey-manager
  ];

  programs = {
    atuin = {
      enable = true;
      settings = {
        filter_mode_shell_up_key_binding = "session";
      };
    };

    fd = {
      enable = true;
      ignores = [".git/"];
    };

    gh = {enable = true;};

    jq = {enable = true;};

    bat = {
      enable = true;
      config = {theme = "rose-pine";};
      themes = {
        rose-pine = {
          src = pkgs.fetchFromGitHub {
            owner = "rose-pine";
            repo = "tm-theme";
            rev = "c4235f9a65fd180ac0f5e4396e3a86e21a0884ec";
            sha256 = "sha256-jji8WOKDkzAq8K+uSZAziMULI8Kh7e96cBRimGvIYKY=";
          };
          file = "dist/themes/rose-pine.tmTheme";
        };
      };
    };

    bottom = {
      enable = true;
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
        set -Ux FZF_DEFAULT_OPTS "
        --color=fg:$subtle,bg:$base,hl:$rose
        --color=fg+:$text,bg+:$overlay,hl+:$rose
        --color=border:$highlightMed,header:$pine,gutter:$base
        --color=spinner:$gold,info:$foam,separator:$highlightMed
        --color=pointer:$iris,marker:$love,prompt:$subtle"

        if test -f /Users/chris/.config/op/plugins.sh
          source /Users/chris/.config/op/plugins.sh
        end
      '';

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
        ".nvim.lua"
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
          plugin = rose-pine;
          extraConfig = ''
            set -g @rose_pine_variant 'main'
            set -g @rose_pine_host 'on' # Enables hostname in the status bar
            set -g @rose_pine_user 'on' # Turn on the username component in the statusbar
            set -g @rose_pine_directory 'on' # Turn on the current folder component in the status bar

            set -g @rose_pine_default_window_behavior 'on' # Forces tmux default window list behaviour
            set -g @rose_pine_show_current_program 'on' # Forces tmux to show the current running program as window name
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
          font = wezterm.font("Iosevka Nerd Font Mono"),
          font_size = 13.0,
          color_scheme = "rose-pine",
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
