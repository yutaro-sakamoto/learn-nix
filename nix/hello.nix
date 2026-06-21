{ stdenv, rustc, lib }:
stdenv.mkDerivation {
    pname = "hello";
    version = "0.0.1";

    src = ../src;
    nativeBuildInputs = [ rustc ];
    buildPhase = ''
        rustc ./hello.rs
    '';
    installPhase = ''
        mkdir -p $out/bin
        cp ./hello $out/bin/hello
    '';

    meta = {
        mainProgram = "hello";
        description = "A hello world program written in Rust";
        longDescription = ''
            This is a demo package for the Nix-Hands-On, which is a hello world program written in Rust.
        '';
        license = lib.licenses.mit;
        platforms = lib.platforms.all;
    };
}