{ options, config, lib, inputs, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (pkgs) stdenv discord;

  # discord = if stdenv.isDarwin then pkgs.discord-mac else pkgs.discord;
  cfg = config.modules.desktop.social.discord;
in {
  options.modules.desktop.social.discord = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    # nixpkgs.overlays = [ inputs.mac-overlay.overlays.discord-mac ];
    environment.systemPackages = [ discord ];
  };
}
