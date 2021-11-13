{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) nodejs yarn;

  cfg = config.modules.dev.node;
in {
  options.modules.dev.node = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      nodejs
      yarn
    ];
  };
}
