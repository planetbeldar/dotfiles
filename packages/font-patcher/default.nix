{ lib, pkgs, stdenv, platforms, fetchurl, ... }:
let
  inherit (lib) licenses platforms;
  inherit (lib.attrsets) mapAttrsToList;

  pname = "font-patcher";
  version = import ./version.nix;
  path = "nerd-fonts";

  commit = "38f76ec69fa3546784dd8beab3caf9c2ede9b92d";
  contents = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/${commit}";

  script_src = fetchurl {
    url = "${contents}/font-patcher";
    sha256  = "06gn3vs6bhpmkaqfilglf5r8kg9miaqpq0psglf0difvgbkjkppl";
  };

  font-patcher = stdenv.mkDerivation {
    inherit pname version;

    buildInputs = with pkgs; [
      fontforge
    ];

    srcs = [script_src] ++
      mapAttrsToList (name: value: fetchurl ({
        url = "${contents}/${name}";
        sha256 = value;
      })) (import ./files.nix);

    phases = "installPhase";

    installPhase = ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG -p $out/${path}/glyphs

      for file_hash in $srcs; do
        file=$(stripHash $file_hash)

        if [[ $file == $pname ]]; then
          $DRY_RUN_CMD cp $VERBOSE_ARG $file_hash $out/${path}/$file
          $DRY_RUN_CMD chmod $VERBOSE_ARG +x $out/${path}/$file
        else
          $DRY_RUN_CMD cp $VERBOSE_ARG $file_hash $out/${path}/glyphs/$file
        fi
      done
    '';

    meta = {
      homepage = "https://www.nerdfonts.com";
      description = "Wrapper/extension for font-patcher script from nerdfonts";
      license = licenses.mit;
      platforms = platforms.unix;
      maintainers = [];
    };
  };

  fp_dir = "${font-patcher}/${path}";
in
pkgs.writeShellScriptBin "font-patcher" ''
  echo "Wrapper/extension for nerd-fonts font-patcher ${fp_dir}";

  files=()
  rest=()

  for arg in "$@"
  do
    if [[ -f $arg ]]; then
      files+=($arg)
    else
      rest+=($arg)
    fi
  done

  if [[ ''${#files[@]} -eq 0 ]]; then
    ${pkgs.fontforge}/bin/fontforge -script ${fp_dir}/font-patcher "$@"
    exit 0
  fi

  for file in ''${files[@]}
  do
    ${pkgs.fontforge}/bin/fontforge -script ${fp_dir}/font-patcher --glyphdir ${fp_dir}/glyphs/ ''${rest[@]} $file
  done
''
