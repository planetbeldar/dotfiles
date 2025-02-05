{ options, config, lib, inputs, pkgs, ... }:
let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv spotify;

  cfg = config.modules.desktop.media.spotify;
in {
  options.modules.desktop.media.spotify = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ spotify ];
  };
}
