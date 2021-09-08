{ options, config, pkgs, lib, ... }:
with lib;
let
  inherit (pkgs.stdenv) isDarwin;
  cfg = config.modules.shell.m-cli;
in {
  options.modules.shell.m-cli = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf (cfg.enable && isDarwin) {
    environment.systemPackages = [
      pkgs.m-cli
    ];
  };
}
