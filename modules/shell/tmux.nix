{ config, options, inputs, lib, pkgs, ... }:
let
  inherit (lib) mkIf util;

  cfg = config.modules.shell.tmux;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.tmux = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
    };
  };
}
