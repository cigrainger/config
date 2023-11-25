{...}: {
  imports = [../common/configuration.nix];

  nix = {
    configureBuildUsers = true;
    settings = {
      substituters = [
        "https://cache.nixos.org/"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      trusted-users = [
        "@admin"
      ];
    };
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  users.users."chris".home = "/Users/chris";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    taps = ["homebrew/services" "homebrew/cask-fonts"];
    brews = [
      "act"
      "asdf"
      "awscli"
      "gcc"
      "imagemagick"
      "libomp"
      "lua-language-server"
      "pinentry-mac"
      "wxwidgets"
      "reattach-to-user-namespace"
      {
        name = "redis";
        restart_service = "changed";
      }
    ];
    casks = [
      "1Password"
      "1password-cli"
      "anki"
      "authy"
      "bartender"
      "brave-browser"
      "calibre"
      "chrysalis"
      "dash"
      "discord"
      "element"
      "firefox"
      "github"
      "iina"
      "insomnia"
      "iterm2"
      "karabiner-elements"
      "linear-linear"
      "loom"
      "mactex-no-gui"
      "notion"
      "raycast"
      "font-roboto-mono"
      "font-iosevka-nerd-font"
      "font-victor-mono-nerd-font"
      "rstudio"
      "signal"
      "tableplus"
      "tailscale"
      "textual"
      "tidal"
      "transmission"
      "unetbootin"
      "viscosity"
      "visual-studio-code"
      "zoom"
      "zotero"
    ];
  };
}
