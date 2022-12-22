{ pkgs, lib, ... }:

{
  imports = [ ../common/configuration.nix ];

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
      upgrade = true;
      cleanup = "zap";
    };
    brewPrefix = "/opt/homebrew/bin";
    extraConfig = ''
      brew "redis", restart_service: :changed
      brew "stripe/stripe-mock/stripe-mock", restart_service: :changed
    '';
    brews = [
      "act"
      "asdf"
      "awscli"
      "flyctl"
      "gcc"
      "imagemagick"
      "pinentry-mac"
      "wxwidgets"
    ];
    casks = [
      "1Password"
      "authy"
      "bartender"
      "brave-browser"
      "calibre"
      "chrysalis"
      "dash"
      "discord"
      "element"
      "firefox"
      "font-hasklug-nerd-font"
      "font-iosevka-nerd-font"
      "font-monoid-nerd-font"
      "github"
      "iina"
      "insomnia"
      "iterm2"
      "karabiner-elements"
      "linear-linear"
      "loom"
      "mactex-no-gui"
      "maestral"
      "paw"
      "raycast"
      "rstudio"
      "signal"
      "tableplus"
      "textual"
      "tidal"
      "transmission"
      "unetbootin"
      "viscosity"
      "visual-studio-code"
      "wickrme"
      "zoom"
      "zotero"
    ];
  };
}
