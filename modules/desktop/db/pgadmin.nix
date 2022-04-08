{ config, options, lib, inputs, pkgs, ... }:

let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv pgadmin4;

  cfg = config.modules.db.pgadmin;
in {
  options.modules.desktop.db.pgadmin = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf stdenv.isDarwin {
      nixpkgs.overlays = [ inputs.mac-overlay.overlays.pgadmin4-mac ];
    })
    {
      environment.systemPackages = [ pgadmin4 ];
    }
  ]);
}
