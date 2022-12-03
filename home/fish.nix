{ pkgs, ... }:

let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "0.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "d9e5c6d1e3b2c6f6f344f7663691c4c8e7ebeb4c";
      sha256 = "sha256-k0nYjGjiTS0TOnYXoZg7w9UksBMLT+Bq/fJI3f9qqBg=";
    };
  };
in
{
  xdg.configFile."tmuxp" = {
    source = ../configs/tmuxp;
    recursive = true;
  };

  xdg.configFile."btop" = {
    source = ../configs/btop;
    recursive = true;
  };

  programs = {
    fish = {
      enable = true;

      shellInit = ''
        fish_vi_key_bindings insert
        eval $(/opt/homebrew/bin/brew shellenv)
        ulimit -n 10240
      '';

      interactiveShellInit = ''
        set fish_greeting
        set -Ux FZF_DEFAULT_OPTS "
         --color=fg:#e0def4,bg:#1f1d2e,hl:#6e6a86
         --color=fg+:#908caa,bg+:#191724,hl+:#908caa
         --color=info:#9ccfd8,prompt:#f6c177,pointer:#c4a7e7
         --color=marker:#ebbcba,spinner:#eb6f92,header:#ebbcba"
        set fzf_preview_dir_cmd exa --icons --all --color=always
        set -gx AWS_VAULT_PROMPT "ykman"
        set -gx EDITOR "hx"
        set -gx GIT_PAGER "delta --dark"
        set -x GPG_TTY (tty)
        set -gx ERL_AFLAGS "-kernel shell_history_enabled"
        set -gx ZK_NOTEBOOK_DIR "/Users/chris/code/notes"
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

      shellAliases = {
        cat = "bat";
        ls = "exa --icons --color=auto";
        ll = "exa -lah --icons";
        ave = "aws-vault exec";
        avl = "aws-vault login";
        lazygit = "TERM=xterm-256color command lazygit";
        vim = "nvim";
        vi = "nvim";
      };

      plugins = [
        {
          name = "fzf.fish";
          src = pkgs.fetchFromGitHub {
            owner = "PatrickF1";
            repo = "fzf.fish";
            rev = "17fcc74029bbd88445712752a5a71bc64aa3994c";
            sha256 = "sha256-WRrPd/GuXHJ9uYvhwjwp9AEtvbfMlpV0xdgNyfx43ok=";
          };
        }
        {
          name = "catppuccin.fish";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "fish";
            rev = "0fd0c48a844636c6082f633cc4f2800abb4b6413";
            sha256 = "sha256-GLb1BkN0nQ4M60JcVIGMnr9C7RKhpev5FUoQjZS5G2A=";
          };
        }
      ];
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      plugins = with pkgs.tmuxPlugins; [ yank vim-tmux-navigator catppuccin ];
      extraConfig = ''
        set -sg escape-time 0
        set -g mouse on
      '';
      tmuxp.enable = true;
    };

    starship = {
      enable = true;
      # Configuration written to ~/.config/starship.toml
      settings = {
        command_timeout = 1000;
        aws.style = "bold #ffb86c";
        cmd_duration.style = "bold #f1fa8c";
        directory.style = "bold #50fa7b";
        hostname.style = "bold #ff5555";
        git_branch.style = "bold #ff79c6";
        git_status.style = "bold #ff5555";
        username = {
          format = "[$user]($style) on ";
          style_user = "bold #bd93f9";
        };
        character = {
          success_symbol = "[λ](bold #50fa7b)";
          error_symbol = "[λ](bold #ff5555)";
          vicmd_symbol = "[λ](bold #ffb86c)";
        };
      };
    };
  };
}

