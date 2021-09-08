{ options, config, lib, pkgs, ... }:
with lib;
let
  inherit (pkgs.stdenv) isDarwin;
  cfg = config.modules.desktop.social.discord;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.social.discord = {
    enable = util.mkBoolOpt false;
  };

  # nix derivation not supported on macos, use brew as backup
  config = mkIf cfg.enable (mkMerge [
    (mkIf (!isDarwin) {
      user.packages = with pkgs; [
        discord
      ];
    })
    (mkIf isDarwin {
      homebrew.casks = [ "discord" ];
    })
  ]);
}
