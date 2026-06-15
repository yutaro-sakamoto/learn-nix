{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          hello = pkgs.stdenv.mkDerivation {
            name = "hello";
            src = ./hello-2.12.tar.gz;
            buildPhase = ''
              make
            '';
            installPhase = ''
              mkdir -p $out/bin
              cp hello $out/bin
            '';
          };
        };
      }
    );
}