{ options, config, lib, inputs, pkgs, ... }:
let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv;

  discord = if stdenv.isDarwin then pkgs.discord-mac else pkgs.discord;
  cfg = config.modules.desktop.social.discord;
in {
  options.modules.desktop.social.discord = { enable = util.mkBoolOpt false; };

  # nix derivation not supported on macos, use brew as backup
  config = mkIf cfg.enable (mkMerge [
    {
      nixpkgs.overlays = [ inputs.discord-mac.overlay ];
      environment.systemPackages = [ discord ];
    }
  ]);
}
