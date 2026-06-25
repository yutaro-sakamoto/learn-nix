# libcobj: opensourcecobol4j の Java ランタイムライブラリ部分。
# upstream は ./gradlew shadowJar でビルドするが、gradlew は Gradle 本体と
# Maven 依存をネットワークから取得するため Nix の sandbox では失敗する。
# そこで nixpkgs の gradle + mitmCache(FOD で依存をキャッシュ) を使い、
# 依存を ./libcobj-deps.json に固定して完全オフラインでビルドする。
#
# 依存ロックの生成/更新:
#   nix run .#libcobj.mitmCache.updateScript
# を実行すると libcobj-deps.json が書き換わる。
{
  stdenv,
  fetchFromGitHub,
  gradle,
  jdk,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libcobj";
  version = "1.1.20";

  src = fetchFromGitHub {
    owner = "opensourcecobol";
    repo = "opensourcecobol4j";
    rev = "a12dd685c58a562c12a09c943c0ac2a00f24d4cc";
    hash = "sha256-hsyEUDQ0LKezX/i9o80CPcL+8QWJJzOW7HsQORyRtv0=";
  };

  # Gradle プロジェクトは libcobj/ サブディレクトリにある。
  sourceRoot = "${finalAttrs.src.name}/libcobj";

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  # mitmCache: 初回は空の ./libcobj-deps.json。updateScript で実体を生成する。
  # ここで指定すると gradle の setup hook が MITM プロキシ経由でキャッシュを
  # 参照し、sandbox 内でもネットワークなしに依存を解決できる。
  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./libcobj-deps.json;
  };

  # デフォルトの assemble ではなく shadowJar(fat jar) を作る。
  gradleBuildTask = "shadowJar";

  # test は testcontainers(Docker) 等が必要なので無効化。
  doCheck = false;
  dontUseGradleCheck = true;

  # toolchain の自動ダウンロード(foojay)を抑止し、gradle 同梱の JDK を使う。
  gradleFlags = [ "-Dorg.gradle.java.installations.auto-download=false" ];

  installPhase = ''
    runHook preInstall

    install -Dm644 app/build/libs/libcobj.jar \
      $out/lib/opensourcecobol4j/libcobj.jar

    for s in cobj-idx cobj-api; do
      install -Dm755 bin/$s $out/bin/$s
      wrapProgram $out/bin/$s \
        --prefix PATH : ${jdk}/bin \
        --prefix CLASSPATH : $out/lib/opensourcecobol4j/libcobj.jar
    done

    runHook postInstall
  '';

  meta = {
    description = "Java runtime library for opensource COBOL 4J";
    homepage = "https://github.com/opensourcecobol/opensourcecobol4j";
  };
})
