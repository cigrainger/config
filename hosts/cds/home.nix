{pkgs, ...}: {
  home.packages = with pkgs; [
    mas
    obsidian
  ];

  programs.git = {
    extraConfig = {
      gpg = {
        "ssh" = {
          program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
        format = "ssh";
      };
      url = {"https://github.com" = {insteadOf = "git://github.com/";};};
    };
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBIx4VvOw1EP5oCaWa6OTB9oJxZMkd9gQj8Kwf3lcC5y";
      signByDefault = true;
    };
  };
}
