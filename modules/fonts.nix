{ options, config, pkgs, lib, ... }:
let
  inherit (lib) mkMerge mkIf;
  inherit (pkgs) stdenv nerdfonts fontconfig;
  inherit (pkgs.local) font-patcher input-nerd-fonts;
in (mkMerge [
  {
    fonts = {
      enableFontDir = true;
      fonts = [
        (nerdfonts.override {
          fonts = [ "SourceCodePro" "Iosevka" "Inconsolata" ];
        })
        (input-nerd-fonts.override { name = "InputMono-.*(Thin|Light).*"; })
      ];
    };

    environment.systemPackages = [
      fontconfig # fc-list et al.
      font-patcher
    ];
  }
  (mkIf stdenv.isDarwin {
    environment.etc.fonts.source = "${fontconfig.out}/etc/fonts"; # default fontconfig configuration
    home.dataFile.fonts.source = "/Library/Fonts"; # link installed fonts for fontconfig
  })
])
