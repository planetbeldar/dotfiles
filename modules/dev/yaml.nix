{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) nodePackages;

  cfg = config.modules.dev.yaml;
in {
  options.modules.dev.yaml = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      nodePackages.yaml-language-server
    ];
  };
}
