{ options, config, pkgs, lib, ... }:
let
  inherit (pkgs) nerdfonts fontconfig;
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

  environment.systemPackages = [
    fontconfig # fc-list
    font-patcher
  ];
}
