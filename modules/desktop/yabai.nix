{ options, config, lib, pkgs, inputs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (lib) mkIf mkEnableOption;

  yabai = pkgs.yabai.overrideAttrs(drv:
    let version = "7.1.2";
    in {
      inherit version;
      src = pkgs.fetchzip {
        url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
        hash = "sha256-4ZJs7Xpou0Ek0CCCjbK47Nu/XPpuTpBDU8GJz5AsaUg=";
      };
    });
  cfg = config.modules.desktop.yabai;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.yabai = { enable = mkEnableOption "enable yabai service"; };

  config = mkIf cfg.enable {

    services.yabai = with pkgs; {
      enable = true;
      package = yabai;
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
