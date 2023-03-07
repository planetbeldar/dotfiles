{ config, options, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) nodejs yarn;
  inherit (pkgs.nodePackages)
    vscode-json-languageserver typescript-language-server typescript
    stylelint js-beautify;
  inherit (pkgs.vscode-extensions.dbaeumer) vscode-eslint;

  cfg = config.modules.dev.web;
in {
  options.modules.dev.web = {
    enable = mkEnableOption "enable JS, TS, HTML, JSON...";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      nodejs
      yarn

      vscode-eslint #https://github.com/emacs-lsp/lsp-mode/wiki/LSP-ESlint-integration
      vscode-json-languageserver
      typescript-language-server
      typescript
      stylelint
      js-beautify
    ];
  };
}
