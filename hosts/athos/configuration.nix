# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [../common/configuration.nix ./hardware-configuration.nix];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
    };
  };

  nix.settings.trusted-users = ["root" "chris"];

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  time.timeZone = "Europe/Amsterdam";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "nl_NL.UTF-8";
      LC_IDENTIFICATION = "nl_NL.UTF-8";
      LC_MEASUREMENT = "nl_NL.UTF-8";
      LC_MONETARY = "nl_NL.UTF-8";
      LC_NAME = "nl_NL.UTF-8";
      LC_NUMERIC = "nl_NL.UTF-8";
      LC_PAPER = "nl_NL.UTF-8";
      LC_TELEPHONE = "nl_NL.UTF-8";
      LC_TIME = "nl_NL.UTF-8";
    };
  };

  services = {
    xserver = {
      videoDrivers = ["nvidia"];
      layout = "us";
      xkbVariant = "";
    };

    tailscale.enable = true;

    fwupd.enable = true;

    openssh = {
      enable = true;
      settings = {PasswordAuthentication = false;};
    };
  };

  users = {
    mutableUsers = false;
    users.chris = {
      isNormalUser = true;
      home = "/home/chris";
      description = "Christopher Grainger";
      extraGroups = ["wheel" "networkmanager" "docker"];
      hashedPassword = "$6$RkxvMra2G8J0$RDJzuC2A9gd3xybyVIqPf2WAgY.ptEmXggKd5HSC7YfXuOb84yfdlIkDKTdEgCod1.zhXFUqwitisr8./v9ZI.";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJghIJnlaP9mmCsjd7P/Ea4msZk+/tjMAvjyg06q6PJC chris@amplified.ai"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILAvJOgkTHaMO9wPw2CcwDra2WXrQY725IlZjg8u+8GK chris@amplified.ai"
      ];
      shell = pkgs.fish;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      enableNvidia = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
