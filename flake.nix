{
  description = "opensource COBOL 4J package";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs =
    {
      nixpkgs, flake-utils, ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          hello = pkgs.callPackage ./cobol/oc4j.nix { } ;
          default =  pkgs.callPackage ./cobol/oc4j.nix { } ;
        };
      }
    );
}