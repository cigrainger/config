{
  pkgs,
  lib,
  ...
}: {
  nix = {
    package = pkgs.nixUnstable;

    extraOptions =
      ''
        auto-optimise-store = true
        experimental-features = nix-command flakes
      ''
      + lib.optionalString (pkgs.system == "aarch64-darwin") ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';
  };

  programs = {
    fish.enable = true;
  };

  environment = {
    extraOutputsToInstall = [
      "doc"
      "info"
      "devdoc"
    ];

    pathsToLink = ["/share/fish" "/share/doc"];

    shells = with pkgs; [fish];

    variables = {
      EDITOR = "hx";
    };
  };
}
