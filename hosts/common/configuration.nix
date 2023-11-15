{ pkgs, lib, system, ... }:

{
  nix = {
    package = pkgs.nixUnstable;

    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };

  programs = {
    fish.enable = true;
  };

  environment = {
    pathsToLink = [ "/share/fish" ];

    shells = with pkgs; [ fish ];

    variables = {
      EDITOR = "nvim";
    };
  };
}
