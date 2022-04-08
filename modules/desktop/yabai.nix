{ options, config, lib, pkgs, inputs, ... }:
let
  inherit (lib) util mkIf;

  cfg = config.modules.desktop.yabai;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.yabai = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.yabai ];

    services.yabai = {
      enable = true;
      package = pkgs.yabai;
      # check for environment var specifying if SIP has been disabled (active choice)?
      enableScriptingAddition = true;
    };

    home.configFile = {
      "yabai/yabairc".source = "${configDir}/yabai/yabairc";
    };
  };
}
