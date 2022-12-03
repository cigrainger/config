{ pkgs, lib, ... }:
{
  nixpkgs.config.allowBroken = true;
  nix = {
    package = pkgs.nixUnstable;
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

    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

  };

  users.users."chris".home = "/Users/chris";

  programs = {
    fish.enable = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

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

  environment = {
    etc."elixir-ls/language_server.sh".source =
      "${pkgs.elixir_ls}/lib/language_server.sh";

    pathsToLink = [ "/share/fish" ];
    shells = with pkgs; [ fish ];
variables = {
EDITOR = "nvim";
};
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      recursive
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };

}
