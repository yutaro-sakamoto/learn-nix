{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      nur,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        # `nur.overlays.<overlayの名前>`ではなく`nur.overlay`
        # `outputs.overlay`は現在非推奨だが恐らく後方互換性のために残されている
        overlays = [ nur.overlay ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
        packages = {
          default = pkgs.nur.repos.mic92.hello-nur;
        };
      }
    );
}