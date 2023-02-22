{ config, options, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) nodejs yarn;
  inherit (pkgs.nodePackages)
    eslint vscode-json-languageserver typescript-language-server typescript
    stylelint js-beautify;

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
      vscode-json-languageserver
      typescript-language-server
      typescript
      stylelint
      js-beautify
    ];
  };
}
