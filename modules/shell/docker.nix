{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) docker;

  cfg = config.modules.shell.docker;
in {
  options.modules.shell.docker = { enable = mkEnableOption "enable docker"; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ docker ];
  };
}
