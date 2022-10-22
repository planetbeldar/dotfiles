{ config, options, lib, inputs, pkgs, ... }:

let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv dbeaver;

  cfg = config.modules.desktop.db.dbeaver;
in {
  options.modules.desktop.db.dbeaver = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ dbeaver ];
  };
}
