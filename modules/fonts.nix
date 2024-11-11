{ options, config, pkgs, lib, ... }:
let
  inherit (lib) mkMerge mkIf;
  inherit (pkgs) nerd-font-patcher stdenv nerdfonts fontconfig recursive;
  inherit (pkgs.local) input-nerd-fonts;
in (mkMerge [
  {
    fonts = {
      # fontDir.enable = true;
      packages = [
        (nerdfonts.override {
          fonts = [ "SourceCodePro" "Iosevka" "Inconsolata" "IBMPlexMono" "JetBrainsMono" "NerdFontsSymbolsOnly" "Recursive" ];
        })
        (input-nerd-fonts.override { name = "InputMono-.*(Thin|Light).*"; })
        recursive
      ];
    };

    environment.systemPackages = [
      fontconfig # fc-list et al.
      nerd-font-patcher
    ];
  }
  (mkIf stdenv.isDarwin {
    environment.etc.fonts.source = "${fontconfig.out}/etc/fonts"; # default fontconfig configuration
    home.dataFile.fonts.source = config.lib.file.mkOutOfStoreSymlink "/Library/Fonts"; # link installed fonts for fontconfig
  })
])
