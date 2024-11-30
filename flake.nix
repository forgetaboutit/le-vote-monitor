{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    dream2nix.url = "github:nix-community/dream2nix";
  };

  outputs = {
    self,
    nixpkgs,
    dream2nix,
  }: let
    system = "x86_64-linux";
  in {
    packages.${system} = {
      monitor-src = dream2nix.lib.evalModules {
        packageSets.nixpkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./default.nix
          {
            paths.projectRoot = ./.;
            paths.projectRootFile = "flake.nix";
            paths.package = ./.;
          }
        ];
      };
      monitor-app = let
        app-src = self.packages.${system}.monitor-src;
        node = nixpkgs.legacyPackages.${system}.nodejs_22;
      in
        nixpkgs.legacyPackages.${system}.writeShellScriptBin "vote-monitor" ''
          ${node}/bin/node ${app-src}/lib/node_modules/stadtwerke-le-vote-monitor-src/index.js
        '';
      default = self.packages.${system}.monitor-app;
    };
  };
}
