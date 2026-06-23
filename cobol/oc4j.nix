 { stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  pname = "o9pensourcecobol4j";
  version = "1.1.20";
  src = fetchFromGitHub {
    owner = "opensourcecobol";
    repo = "opensourcecobol4j";
    rev = "a12dd685c58a562c12a09c943c0ac2a00f24d4cc";
    hash = "sha256-hsyEUDQ0LKezX/i9o80CPcL+8QWJJzOW7HsQORyRtv0=";
  };
  buildPhase = ''
    ./configure --prefix=$out
    make
  '';
  installPhase = ''
    make install
  '';
}