{ config, options, inputs, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge util;
  inherit (pkgs) stdenv sshfs;

  cfg = config.modules.shell.sshfs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.sshfs = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable (mkMerge [
    (mkIf stdenv.isDarwin {
      homebrew.casks = [ "macfuse" ];
    })
    {
      environment.systemPackages = [ sshfs ];
    }
  ]);
}
