{ pkgs, pname }:
let
  version = "1.1.71.560.gc21c3367-40";
  inherit (pkgs) stdenv lib undmg;
in stdenv.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url = "https://download.scdn.co/Spotify.dmg";
    sha256 = "1m8a2rj1pwxcmszsnnx5m2sg3ipwdfg4zd4879r2r35s2bwsdv91";
  };

  phases = [ "unpackPhase" "installPhase" ];

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -R Spotify.app $out/Applications/
  '';

  meta = {
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
