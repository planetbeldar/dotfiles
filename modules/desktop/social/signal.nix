{ inputs, options, config, lib, pkgs, ... }:
with lib;
let
  inherit (pkgs) stdenv;

  signal = if stdenv.isDarwin then pkgs.signal-mac else pkgs.signal-desktop;
  cfg = config.modules.desktop.social.signal;
in {
  options.modules.desktop.social.signal = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.signal-mac ];
    environment.systemPackages = [ signal ];
  };
}
