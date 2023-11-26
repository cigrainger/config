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

  services = {
    nix-daemon.enable = true;
    redis.enable = true;
  };

  users.users."chris".home = "/Users/chris";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    taps = ["homebrew/services" "homebrew/cask-fonts"];
    casks = [
      "1Password"
      "1password-cli"
      "authy"
      "bartender"
      "calibre"
      "chrysalis"
      "dash"
      "discord"
      "element"
      "firefox"
      "iina"
      "karabiner-elements"
      "linear-linear"
      "loom"
      "notion"
      "raycast"
      "font-roboto-mono"
      "font-iosevka-nerd-font"
      "font-victor-mono-nerd-font"
      "signal"
      "tailscale"
      "viscosity"
      "zoom"
      "zotero"
    ];
  };
}
