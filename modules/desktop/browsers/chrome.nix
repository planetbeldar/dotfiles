{ options, config, lib, inputs, pkgs, ... }:
let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) google-chrome;

  cfg = config.modules.desktop.browsers.chrome;
in {
  options.modules.desktop.browsers.chrome = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [
    ];
  };
}
