{ config, options, lib, inputs, pkgs, ... }:

let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv;

  cfg = config.modules.desktop.db.pgadmin;
  pgadmin = if stdenv.isDarwin then pkgs.pgadmin4-mac else pkgs.pgadmin4;
in {
  options.modules.desktop.db.pgadmin = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.pgadmin4-mac ];
    environment.systemPackages = [ pgadmin ];
  };
}
