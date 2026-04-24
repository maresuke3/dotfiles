{
  description = "Darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    mkHost = hostname: nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./common.nix
        ./hosts/${hostname}.nix
      ];
    };
  in {
    darwinConfigurations = {
      "U0031" = mkHost "U0031";
    };
  };
}
