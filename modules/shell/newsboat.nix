{ options, config, pkgs, lib, ... }:
with lib;
let
  inherit (pkgs) newsboat;

  cfg = config.modules.shell.newsboat;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.newsboat = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      newsboat
    ];

    home.configFile = {
      "newsboat" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/newsboat";
        recursive = true;
      };
    };
  };
}
