{ options, config, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (pkgs) haskellPackages haskell;

  cfg = config.modules.desktop.kmonad;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.kmonad = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    # environment.systemPackages = [ haskellPackages.kmonad ];
    # environment.systemPackages = [

    # ];

    home.configFile = {
      "kmonad" = {
        source = lib.util.mkOutOfStoreSymlink "${configDir}/kmonad";
        recursive = true;
      };
    };
  };
}
