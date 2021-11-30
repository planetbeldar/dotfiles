{ config, options, inputs, lib, pkgs, ... }:
let
  inherit (lib) mkIf util;

  cfg = config.modules.shell.xkbswitch;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.xkbswitch = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.xkbswitch ];
    environment.systemPackages = [ pkgs.xkbswitch ];
  };
}
