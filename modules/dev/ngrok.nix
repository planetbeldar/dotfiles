{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkIf util;
  inherit (pkgs) ngrok;

  cfg = config.modules.dev.ngrok;
  configDir = config.dotfiles.configDir;
in {
  options.modules.dev.ngrok = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ ngrok ];
  };
}
