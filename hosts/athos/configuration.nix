{
  pkgs,
  lib,
  ...
}: {
  imports = [../common/configuration.nix ./hardware-configuration.nix];

  hardware = {
    bluetooth.enable = true;
    nvidia.modesetting.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  nix.settings.trusted-users = ["root" "chris"];

  nixpkgs.config = {
    allowUnfree = true;
    enableRedistributableFirmware = true;
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  time.timeZone = "Australia/Melbourne";

  networking = {
    useDHCP = false;
    interfaces.enp59s0.useDHCP = true;
    interfaces.enp60s0.useDHCP = true;
    interfaces.wlp58s0.useDHCP = true;
    nameservers = ["1.1.1.1" "1.0.0.1"];
    networkmanager.enable = true;
    firewall = {
      extraCommands = ''
        ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
      '';
    };
  };

  security.rtkit.enable = true;

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
    };
  };

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["multi-user.target"];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey ${builtins.getEnv "TAILSCALE_AUTHKEY"}
    '';
  };

  services = {
    cron = {
      enable = true;
      systemCronJobs = [
        "*/0 11 * * * bash -c 'cd \"$(navi info cheats-path)/<user>__<repo>\" && git pull -q origin master'"
      ];
    };

    xserver.videoDrivers = ["nvidia" "modesetting"];
    tailscale.enable = true;

    fwupd = {enable = true;};

    openssh = {
      enable = true;
      settings = {passwordAuthentication = false;};
    };

    redis.servers = {"" = {enable = true;};};

    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
    picom = {enable = true;};
    nfs.server.enable = true;
  };

  programs = {
    dconf.enable = true;
    mosh.enable = true;
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  virtualisation = {
    virtualbox.host.enable = true;
    podman = {
      dockerCompat = true;
      dockerSocket.enable = true;
      enable = true;
      enableNvidia = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
