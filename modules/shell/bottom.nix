{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.bottom;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.bottom = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.bottom
    ];

    home.configFile = {
      "bottom" = { source = "${configDir}/bottom"; recursive = true; };
    };
  };
}
