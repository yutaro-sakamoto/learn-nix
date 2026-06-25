# opensource COBOL 4J: COBOL -> Java トランスパイラ。
# C 製のトランスパイラ本体(cobj)を autotools でビルドし、別派生 libcobj が
# 生成した Java ランタイム(libcobj.jar / cobj-idx / cobj-api)を取り込む。
# libcobj 部分は Gradle ビルドなので libcobj.nix 側に分離している。
{
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  makeWrapper,
  flex,
  bison,
  jdk,
  libcobj,
}:
stdenv.mkDerivation {
  pname = "opensourcecobol4j";
  version = "1.1.20";

  src = fetchFromGitHub {
    owner = "opensourcecobol";
    repo = "opensourcecobol4j";
    rev = "a12dd685c58a562c12a09c943c0ac2a00f24d4cc";
    hash = "sha256-hsyEUDQ0LKezX/i9o80CPcL+8QWJJzOW7HsQORyRtv0=";
  };

  nativeBuildInputs = [
    autoreconfHook # configure.ac から configure を生成 (autom4te 等を含む)
    makeWrapper
    flex
    bison
  ];

  # Gradle 製の libcobj サブディレクトリは別派生でビルド済みなので、
  # ここでは SUBDIRS から外して C 部分だけをビルドする。
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail "SUBDIRS = lib cobj bin config copy tests libcobj" \
                     "SUBDIRS = lib cobj bin config copy tests"
  '';

  configureFlags = [ "--prefix=${placeholder "out"}" ];

  # libcobj 派生の成果物(jar と補助スクリプト)を取り込む。
  postInstall = ''
    mkdir -p $out/lib/opensourcecobol4j
    cp ${libcobj}/lib/opensourcecobol4j/libcobj.jar $out/lib/opensourcecobol4j/

    # 生成された Java を動かすコマンドが java/javac と libcobj.jar を
    # 見つけられるよう、$out/bin の各コマンドをラップする。
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH : ${jdk}/bin \
        --prefix CLASSPATH : $out/lib/opensourcecobol4j/libcobj.jar
    done
  '';

  meta = {
    description = "opensource COBOL 4J - a COBOL to Java transpiler";
    homepage = "https://github.com/opensourcecobol/opensourcecobol4j";
  };
}
