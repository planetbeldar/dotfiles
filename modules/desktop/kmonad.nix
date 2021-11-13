{ options, config, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (pkgs) haskellPackages;

  cfg = config.modules.desktop.kmonad;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.kmonad = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ haskellPackages.kmonad ];
  };
}
