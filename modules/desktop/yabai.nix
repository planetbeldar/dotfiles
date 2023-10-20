{ options, config, lib, pkgs, inputs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.desktop.yabai;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.yabai = { enable = mkEnableOption "enable yabai service"; };

  config = mkIf cfg.enable {
    # nixpkgs.overlays = [ inputs.mac-overlay.overlays.yabai ];

    services.yabai = {
      enable = true;
      package = pkgs.yabai;
      # check for environment var specifying if SIP has been disabled (active choice)?
      enableScriptingAddition = true;
    };

    home.configFile = {
      yabai = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/yabai";
        recursive = true;
      };
    };
  };
}
