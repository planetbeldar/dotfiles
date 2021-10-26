{ options, config, lib, pkgs, ... }:
with lib;
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs) discord;

  cfg = config.modules.desktop.social.discord;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.social.discord = { enable = util.mkBoolOpt false; };

  # nix derivation not supported on macos, use brew as backup
  config = mkIf cfg.enable (mkMerge [
    (mkIf isDarwin { homebrew.casks = [ "discord" ]; })
    (mkIf (!isDarwin) { environment.systemPackages = [ discord ]; })
  ]);
}
