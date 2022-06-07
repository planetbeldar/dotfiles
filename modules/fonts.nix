{ options, config, pkgs, lib, ... }:
let
  inherit (lib) mkMerge mkIf;
  inherit (pkgs) nerd-font-patcher stdenv nerdfonts fontconfig;
  inherit (pkgs.local) input-nerd-fonts;
in (mkMerge [
  {
    fonts = {
      fontDir.enable = true;
      fonts = [
        (nerdfonts.override {
          fonts = [ "SourceCodePro" "Iosevka" "Inconsolata" "IBMPlexMono" "JetBrainsMono" ];
        })
        (input-nerd-fonts.override { name = "InputMono-.*(Thin|Light).*"; })
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
