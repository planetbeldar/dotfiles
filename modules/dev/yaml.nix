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
    user.packages = [
      nodePackages.yaml-language-server
    ];
  };
}
