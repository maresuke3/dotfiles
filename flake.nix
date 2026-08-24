{
  description = "Dotfiles - Darwin + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
  let
    darwinSystem = "aarch64-darwin";
    linuxSystem = "x86_64-linux";
    darwinUsername = "daiki-fukushima";
    linuxUsername = "maresuke";
    overlay = final: prev: {
      direnv = prev.direnv.overrideAttrs (old: {
        doCheck = false;
      });
    };
  in {
    darwinConfigurations."U0031" = nix-darwin.lib.darwinSystem {
      system = darwinSystem;
      modules = [
        { nixpkgs.overlays = [ overlay ]; }
        ./nix/darwin/common.nix
        ./nix/darwin/hosts/U0031.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${darwinUsername} = { ... }: {
            imports = [ ./nix/home/home.nix ];
            home.username = darwinUsername;
            home.homeDirectory = "/Users/${darwinUsername}";
          };
        }
      ];
    };

    homeConfigurations."${linuxUsername}" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${linuxSystem};
      modules = [
        ./nix/home/home.nix
        {
          home = {
            username = linuxUsername;
            homeDirectory = "/home/${linuxUsername}";
          };
        }
      ];
    };
  };
}
