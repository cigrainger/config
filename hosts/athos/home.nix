{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    mas
    obsidian
  ];

  programs.git = {
    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };
}
