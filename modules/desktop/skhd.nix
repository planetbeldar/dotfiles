{ options, config, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;

  cfg = config.modules.desktop.skhd;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.skhd = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.skhd.enable = true;
    services.skhd.package = pkgs.skhd;

    home.configFile = { "skhd/skhdrc".source = "${configDir}/skhd/skhdrc"; };
  };
}
