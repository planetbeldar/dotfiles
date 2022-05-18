{ options, config, lib, pkgs, inputs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) stdenv;

  inkscape = if stdenv.isDarwin then pkgs.inkscape-mac else pkgs.inkscape;
  cfg = config.modules.desktop.media.inkscape;
in {
  options.modules.desktop.media.inkscape = {
    enable = mkEnableOption "enable inkscape";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.inkscape-mac ];
    environment.systemPackages = [ inkscape ];
  };
}
