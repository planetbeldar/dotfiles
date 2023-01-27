{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkIf util;
  inherit (pkgs) nginx;

  cfg = config.modules.dev.nginx;
  configDir = config.dotfiles.configDir;
in {
  options.modules.dev.nginx = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ nginx ];

    home.configFile = {
      "nginx".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/nginx";
    };

  };
}
