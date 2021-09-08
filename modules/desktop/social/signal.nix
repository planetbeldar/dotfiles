{ options, config, lib, pkgs, ... }:
with lib;
let
  inherit (pkgs.stdenv) isDarwin;
  cfg = config.modules.desktop.social.signal;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.social.signal = {
    enable = util.mkBoolOpt false;
  };

  # nix derivation not supported on macos, use brew as backup
  config = mkIf cfg.enable (mkMerge [
    (mkIf (!isDarwin) {
      user.packages = with pkgs; [
        signal-desktop
      ];
    })
    (mkIf isDarwin {
      homebrew.casks = [ "signal" ];
    })
  ]);
}
