{ config, options, lib, inputs, pkgs, ... }:

let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) stdenv jetbrains;

  idea = jetbrains.idea-community;
  cfg = config.modules.desktop.ide.idea;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.ide.idea = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ idea ];

    home.configFile = {
      ideavim = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/ideavim";
        recursive = true;
      };
    };
  };
}
