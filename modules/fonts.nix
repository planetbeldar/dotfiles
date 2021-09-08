{ options, config, pkgs, lib, ... }:
with lib;
let
  inherit (pkgs) nerdfonts;
  inherit (pkgs.local) font-patcher input-nerd-fonts;

  config = config.modules.fonts;
in {
  fonts = {
    enableFontDir = true;
    fonts = [
      (nerdfonts.override { fonts = [
                              "SourceCodePro"
                              "Iosevka"
                              "Inconsolata"
                            ];
                          })
      (input-nerd-fonts.override {
        name = "InputMono-*Light*";
      })
    ];
  };

  user.packages = [
    fontconfig # fc-list
    font-patcher
  ];
}
