{ options, config, lib, inputs, pkgs, ... }:
let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv;

  cfg = config.modules.desktop.media.sonos;
in {
  options.modules.desktop.media.sonos = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.sonos-mac ];
    environment.systemPackages = [ pkgs.sonos-mac ];
  };
}
