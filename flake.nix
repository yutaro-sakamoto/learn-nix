{
  description = "hello package written in Rust";

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
          hello = pkgs.callPackage ./nix/hello.nix { };
          default = pkgs.callPackage ./nix/hello.nix { };
        };
      }
    );
}