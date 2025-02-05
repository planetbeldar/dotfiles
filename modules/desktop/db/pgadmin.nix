{ config, options, lib, inputs, pkgs, ... }:

let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv pgadmin4;

  cfg = config.modules.desktop.db.pgadmin;
in {
  options.modules.desktop.db.pgadmin = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pgadmin4 ];
  };
}
