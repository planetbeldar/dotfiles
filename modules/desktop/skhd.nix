{ options, config, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (pkgs) skhd;

  cfg = config.modules.desktop.skhd;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.skhd = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.skhd.enable = true;
    services.skhd.package = skhd;

    # make skhd link to bin
    environment.systemPackages = [ skhd ];

    home.configFile = {
      skhd = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/skhd";
        recursive = true;
      };
    };
  };
}
