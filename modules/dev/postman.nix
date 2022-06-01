{ config, options, lib, pkgs, ... }:
let
  inherit (lib) util mkIf mkEnableOption;
  inherit (pkgs) postman;

  cfg = config.modules.dev.postman;
in {
  options.modules.dev.postman = {
    enable = mkEnableOption "enable postman";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      postman
    ];
  };
}
