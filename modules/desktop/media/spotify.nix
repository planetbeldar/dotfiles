{ options, config, lib, inputs, pkgs, ... }:
let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv;
  inherit (inputs.home-manager.lib) hm;

  spotify = if stdenv.isDarwin then pkgs.spotify-mac else pkgs.spotify;
  cfg = config.modules.desktop.media.spotify;
in {
  options.modules.desktop.media.spotify = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.spotify-mac.overlay ];
    environment.systemPackages = [ spotify ];
  };
}
