{ inputs, options, config, lib, pkgs, ... }:
with inputs.home-manager.lib;
let
  inherit (lib) util mkIf;
  inherit (pkgs) stdenv;

  cfg = config.modules.desktop.term.alacritty;
  configDir = config.dotfiles.configDir;

  alacritty = pkgs.alacritty;
in {
  options.modules.desktop.term.alacritty = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ alacritty ];

    home.configFile = {
      "alacritty" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/alacritty";
        recursive = true;
      };
    };
  };
}
