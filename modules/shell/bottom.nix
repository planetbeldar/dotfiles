{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkIf util;
  inherit (pkgs) bottom;

  cfg = config.modules.shell.bottom;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.bottom = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ bottom ];

    home.configFile = {
      "bottom" = {
        source = "${configDir}/bottom";
        recursive = true;
      };
    };
  };
}
