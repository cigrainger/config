{ pkgs, ... }:

let
  catppuccin-tmux = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2022-12-14";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "4e48b09a76829edc7b55fbb15467cf0411f07931";
      sha256 = "sha256-bXEsxt4ozl3cAzV3ZyvbPsnmy0RAdpLxHwN82gvjLdU=";
    };
    postInstall = ''
      sed -i -e 's|''${PLUGIN_DIR}/catppuccin-selected-theme.tmuxtheme|''${TMUX_TMPDIR}/catppuccin-selected-theme.tmuxtheme|g' $target/catppuccin.tmux
    '';
    meta = with pkgs.lib; {
      homepage = "https://github.com/catppuccin/tmux";
      description = "Soothing pastel theme for Tmux!";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = with maintainers; [ jnsgruk ];
    };
  };

in
{
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
        set -gx EDITOR "nvim"
        set -gx GIT_PAGER "delta --dark"
        set -x GPG_TTY (tty)
        set -gx ERL_AFLAGS "-kernel shell_history_enabled"

        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
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
        lazygit = "TERM=xterm-256color command lazygit";
        vim = "nvim";
        vi = "nvim";
        ls = "exa --icons --color=auto";
        ll = "exa -lah --icons";
        ave = "aws-vault exec";
        avl = "aws-vault login";
        zj = "zellij --layout compact";
      };
    };

    starship =
      let
        flavour = "mocha";
      in
      {
        enable = true;
        settings = {
          format = "$all"; # Remove this line to disable the default prompt format
          palette = "catppuccin_${flavour}";
        } // builtins.fromTOML (builtins.readFile
          (pkgs.fetchFromGitHub
            {
              owner = "catppuccin";
              repo = "starship";
              rev = "3e3e54410c3189053f4da7a7043261361a1ed1bc";
              sha256 = "sha256-soEBVlq3ULeiZFAdQYMRFuswIIhI9bclIU8WXjxd7oY=";
            } + /palettes/${flavour}.toml));
      };

    fzf = {
      enable = true;
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      defaultCommand = "fd --type f";
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'bat {}'" ];
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      keyMode = "vi";
      mouse = true;
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin-tmux;
          extraConfig = ''
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_left_separator "█"
            set -g @catppuccin_right_separator "█"
            set -g @catppuccin_date_time "%Y-%m-%d %H:%M"
          '';
        }
        fuzzback
        vim-tmux-navigator
        yank
      ];
    };
  };
}

