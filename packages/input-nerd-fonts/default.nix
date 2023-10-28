{ lib
, stdenv
, pkgs
, name ? "*" # filter font file names
, ... }:
let
  inherit (lib) attrNames licenses platforms;
  inherit (builtins) concatMap mapAttrs readDir;

  inherit (pkgs) input-fonts nerd-font-patcher;

  pname = "input-nerd-fonts";
  version = "1.2";
in stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs = [ input-fonts nerd-font-patcher ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    echo "Patching Input fonts from ${input-fonts}"
    $DRY_RUN_CMD mkdir $VERBOSE_ARG -p original patched

    $DRY_RUN_CMD find ${input-fonts} \
      -regextype awk \
      -type f -regex ".*/${name}\.ttf" \
        -exec \
      ${nerd-font-patcher}/bin/nerd-font-patcher \
      --complete --careful -out ./patched {} \;
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
