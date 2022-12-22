{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    aws-vault
    awscli2
    bottom
    btop
    cachix
    cargo
    coreutils
    curl
    dog
    du-dust
    duf
    elixir
    elixir_ls
    entr
    fd
    fzf
    gh
    glow
    jq
    lazydocker
    lua
    mosh
    nixfmt
    nixpkgs-fmt
    onefetch
    ripgrep
    rnix-lsp
    rustc
    sd
    shfmt
    signal-cli
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
  ];

  programs = {
    navi.enable = true;

    exa = { enable = true; };

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          lsp.display-messages = true;
          indent-guides.render = true;
        };
        keys.normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
        };
      };
    };

    bat = {
      enable = true;
      config = { theme = "dracula"; };
      themes = {
        dracula = builtins.readFile (pkgs.fetchFromGitHub
          {
            owner = "dracula";
            repo = "sublime"; # Bat uses sublime syntax for its themes
            rev = "c5de15a0ad654a2c7d8f086ae67c2c77fda07c5f";
            sha256 = "sha256-m/MHz4phd3WR56I5jfi4hMXnFf4L4iXVpMFwtd0L0XE=";
          } + "/Dracula.tmTheme");
      };
    };

    zoxide.enable = true;

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
      homedir = "/Users/chris/.gnupg";
      scdaemonSettings = { disable-ccid = true; };
    };
  };
}
