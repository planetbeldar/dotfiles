{ options, config, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;

  cfg = config.modules.desktop.yabai;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.yabai = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.yabai = {
      enable = true;
      # check for environment var specifying if SIP has been disabled (active choice)?
      enableScriptingAddition = true;
      package = pkgs.yabai;
    };

    home.configFile = {
      "yabai/yabairc".source = "${configDir}/yabai/yabairc";
    };
  };
}
