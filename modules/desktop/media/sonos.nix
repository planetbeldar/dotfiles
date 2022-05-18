{ options, config, lib, inputs, pkgs, ... }:
let
  inherit (lib) util mkIf mkMerge mkEnableOption;
  inherit (pkgs) stdenv;

  cfg = config.modules.desktop.media.sonos;
in {
  options.modules.desktop.media.sonos = {
    enable = mkEnableOption "enable sonos";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.sonos-mac ];
    environment.systemPackages = [ pkgs.sonos-mac ];
  };
}
