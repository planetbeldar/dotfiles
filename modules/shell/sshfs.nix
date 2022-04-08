{ config, options, inputs, lib, pkgs, ... }:
let
  inherit (lib) mkIf util;
  inherit (pkgs) stdenv sshfs macfuse;

  cfg = config.modules.shell.sshfs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.sshfs = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.macfuse ];
    environment.systemPackages = [
      macfuse
      sshfs
    ];
  };
}
