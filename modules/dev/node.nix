{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) nodePackages;

  cfg = config.modules.dev.js;
in {
  options.modules.dev.js = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      nodePackages.eslint
      nodePackages.vscode-json-languageserver
      nodePackages.typescript-language-server
    ];
  };
}
