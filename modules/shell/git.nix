{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.git;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      git
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.diff-so-fancy
      gitAndTools.git-crypt
      act
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
    };
  };
}
