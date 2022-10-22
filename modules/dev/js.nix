{ config, options, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) nodejs yarn nodePackages;

  cfg = config.modules.dev.js;
in {
  options.modules.dev.js = {
    enable = mkEnableOption "enable JS, TS, HTML, JSON...";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      nodejs
      yarn

      nodePackages.eslint
      nodePackages.vscode-json-languageserver
      nodePackages.typescript-language-server
      nodePackages.typescript
    ];
  };
}
