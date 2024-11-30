{
  lib,
  config,
  dream2nix,
  ...
}: {
  imports = [
    dream2nix.modules.dream2nix.nodejs-package-lock-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  mkDerivation = {
    src = ./src;
  };

  deps = {nixpkgs, ...}: {
    inherit (nixpkgs) stdenv;
  };

  nodejs-package-lock-v3 = {
    packageLockFile = "${config.mkDerivation.src}/package-lock.json";
  };

  name = "stadtwerke-le-vote-monitor-src";
  version = "1.0.0";
}
