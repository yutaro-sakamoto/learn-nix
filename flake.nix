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
            pname = "hello";
            version = "2.12";
            nativeBuildInputs = with pkgs; [ wget ];
            unpackPhase = ''
             wget https://ftp.gnu.org/gnu/hello/hello-2.12.tar.gz
             tar -xvf hello-2.12.tar.gz
             cd hello-2.12
            '';
          };
        };
      }
    );
}