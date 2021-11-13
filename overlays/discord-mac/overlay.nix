{ pkgs, pname }:
let
  version = "0.0.264";
  inherit (pkgs) stdenv lib undmg;
in stdenv.mkDerivation {
  inherit pname version;

  src = pkgs.fetchurl {
    url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
    sha256 = "f7e8e401d1d1526eef3176cd75e38807cf73e25c4fe76b42d65443ec56ed74cb";
  };

  phases = [ "unpackPhase" "installPhase" ];

  nativeBuildInputs = [ undmg ];

  unpackPhase = ''
    undmg $src
  '';

  installPhase = ''
    mkdir -p $out/Applications
    cp -R Discord.app $out/Applications/
  '';

  meta = {
    # license = lib.licenses.unfree;
    platforms = lib.platforms.darwin;
  };
}
