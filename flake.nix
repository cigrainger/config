{
  description = "Chris's Darwin System";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Environment/system management
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    home-manager,
    fenix,
    ...
  } @ inputs: let
    inherit (darwin.lib) darwinSystem;
    inherit (inputs.nixpkgs-unstable.lib) attrValues optionalAttrs;

    # Configuration for `nixpkgs`
    nixpkgsConfig = {
      config = {allowUnfree = true;};
      overlays = attrValues self.overlays;
    };
  in {
    packages.x86_64-linux.default = fenix.packages.x86_64-linux.latest.toolchain;
    packages.aarch64-darwin.default = fenix.packages.aarch64-darwin.latest.toolchain;
    nixosConfigurations.athos = inputs.nixpkgs-unstable.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [
        {nixpkgs = nixpkgsConfig;}
        ./hosts/athos/configuration.nix
        home-manager.nixosModules.home-manager
        {
          nixpkgs = nixpkgsConfig;
          # `home-manager` config
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.chris = {...}: {
            imports = [
              ./home.nix
              ./home/neovim.nix
              ./home/direnv.nix
            ];

            home = {
              stateVersion = "21.05";
              username = "chris";
              homeDirectory = "/home/chris";
            };
          };
        }
      ];
    };

    darwinConfigurations = {
      cds = darwinSystem {
        specialArgs = {inherit inputs;};
        system = "aarch64-darwin";
        modules = [
          # Main `nix-darwin` config
          ./hosts/cds/configuration.nix
          # `home-manager` module
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.chris = {system, ...}: {
              imports = [
                ./home.nix
                ./home/neovim.nix
                ./home/direnv.nix
              ];

              home = {
                stateVersion = "22.05";
                username = "chris";
                homeDirectory = "/Users/chris";
              };
            };
          }
        ];
      };
    };

    overlays = {
      # Overlay useful on Macs with Apple Silicon
      fenixOverlay = fenix.overlays.default;
      apple-silicon = _: prev:
        optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
          # Add access to x86 packages
          pkgs-x86 = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
            inherit (nixpkgsConfig) config;
          };
        };
    };
  };
}
