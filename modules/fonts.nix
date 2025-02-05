{ options, config, pkgs, lib, ... }:
let
  inherit (lib) mkMerge mkIf;
  inherit (pkgs) nerd-font-patcher stdenv nerdfonts fontconfig;
  inherit (pkgs.local) input-nerd-fonts;
  inherit (pkgs.nerd-fonts) recursive-mono symbols-only jetbrains-mono blex-mono inconsolata iosevka sauce-code-pro;
in (mkMerge [
  {
    fonts = {
      # fontDir.enable = true;
      packages = [
        (input-nerd-fonts.override { name = "InputMono-.*(Thin|Light).*"; })
        recursive-mono symbols-only jetbrains-mono blex-mono inconsolata iosevka sauce-code-pro
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
