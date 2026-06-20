{ stdenv, rustc }:
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
}