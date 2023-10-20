{ config, options, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) nodejs yarn;
  inherit (pkgs.nodePackages)
    vscode-langservers-extracted typescript-language-server typescript
    stylelint js-beautify eslint;

  cfg = config.modules.dev.web;
in {
  options.modules.dev.web = {
    enable = mkEnableOption "enable JS, TS, HTML, JSON...";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      nodejs
      yarn

      eslint
      vscode-langservers-extracted #https://github.com/hrsh7th/vscode-langservers-extracted
      typescript-language-server
      typescript
      stylelint
      js-beautify
    ];
  };
}
