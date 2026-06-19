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
        hello = pkgs.stdenv.mkDerivation {
          pname = "hello";
          version = "0.0.1";
          src = ./src;
          nativeBuildInputs = with pkgs; [ rustc ];
          buildPhase = ''
            rustc ./hello.rs
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp ./hello $out/bin/hello
          '';
        };
      in
      {
        packages = {
          inherit hello;
          default = hello;
        };
      }
    );
}