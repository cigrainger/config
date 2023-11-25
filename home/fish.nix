{pkgs, ...}: {
  xdg.configFile."fish/themes" = {
    source = ../configs/fish/themes;
    recursive = true;
  };

  programs = {
    fish = {
      enable = true;

      shellInit = ''
        fish_vi_key_bindings insert
        if type -q brew
          eval $(/opt/homebrew/bin/brew shellenv)
        end
        ulimit -n 10240
      '';

      interactiveShellInit = ''
        set fish_greeting
        set -gx AWS_VAULT_PROMPT "ykman"
        set -gx EDITOR "hx"
        set -gx GIT_PAGER "delta --dark"
        set -x GPG_TTY (tty)
        set -gx ERL_AFLAGS "-kernel shell_history_enabled"

        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

        fish_add_path /opt/homebrew/bin
        source /Users/chris/.config/op/plugins.sh
      '';

      functions = {
        # This handles the issue (described here: https://github.com/Homebrew/homebrew-core/pull/75755#issuecomment-825381930) with gnupg 2.3.
        ykman = ''
          set -l scdaemon_conf "$HOME/.gnupg/scdaemon.conf"
          if test -e $scdaemon_conf
            rm $scdaemon_conf && pkill gpg-agent
          end
          command ykman $argv
          if not test -e $scdaemon_conf
            echo "disable-ccid" > $scdaemon_conf && pkill gpg-agent
          end
        '';
      };
      plugins = [
        {
          name = "catppuccin";
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
        lazygit = "TERM=xterm-256color command lazygit";
        ls = "exa --icons --color=auto";
        ll = "exa -lah --icons";
        ave = "aws-vault exec";
        avl = "aws-vault login";
        zj = "zellij --layout compact";
      };
    };

    starship = let
      flavour = "mocha";
    in {
      enable = true;
      settings =
        {
          format = "$all"; # Remove this line to disable the default prompt format
          palette = "catppuccin_${flavour}";
        }
        // builtins.fromTOML (builtins.readFile
          (pkgs.fetchFromGitHub
            {
              owner = "catppuccin";
              repo = "starship";
              rev = "3e3e54410c3189053f4da7a7043261361a1ed1bc";
              sha256 = "sha256-soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
            }
            + /palettes/${flavour}.toml));
    };

    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = ["--preview 'tree -C {} | head -200'"];
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = ["--preview 'bat {}'"];
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
  };
}
