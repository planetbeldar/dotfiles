{ lib
, stdenv
, pkgs
, name ? "*" # filter font file names
, ... }:
let
  inherit (lib) attrNames licenses platforms;
  inherit (builtins) concatMap mapAttrs readDir;

  inherit (pkgs) input-fonts;
  inherit (pkgs.local) font-patcher;

  pname = "input-nerd-fonts";
  version = "1.2";
in stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ input-fonts font-patcher ];

  # unpackPhase = "true";
  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    echo "Patching Input fonts"
    $DRY_RUN_CMD mkdir $VERBOSE_ARG -p original patched

    $DRY_RUN_CMD find ${pkgs.input-fonts} \
      -type f -iname "*.ttf" \
      -a -type f -iname "${name}" \
      -exec cp {} ./original \;
    $DRY_RUN_CMD ${pkgs.local.font-patcher}/bin/font-patcher \
      --quiet --complete --careful -out ./patched ./original/*
  '';

  installPhase = ''
    echo "Installing patched Input fonts"
    $DRY_RUN_CMD mkdir $VERBOSE_ARG -p $out/share/fonts
    sleep 2
    $DRY_RUN_CMD mv $VERBOSE_ARG ./patched/* $out/share/fonts
  '';

  meta = {
    homepage = "https://input.djr.com";
    description = "Patch and install Input Nerd Fonts";
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
