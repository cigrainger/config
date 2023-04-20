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
    taps = [ "homebrew/services" "stripe/stripe-mock" ];
    brews = [
      "act"
      "asdf"
      "awscli"
      "flyctl"
      "gcc"
      "helix"
      "imagemagick"
      "pinentry-mac"
      "wxwidgets"
      "reattach-to-user-namespace"
    ];
    casks = [
      "1Password"
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
      "maestral"
      "raycast"
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
