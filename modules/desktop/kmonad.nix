{ options, config, inputs, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;

  cfg = config.modules.desktop.kmonad;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.kmonad = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.kmonad-mac ];

    services.kmonad-mac = {
      enable = true;
      package = pkgs.kmonad-mac;
      keymap =  "${configDir}/kmonad/config.kbd";
    };

    home.configFile = {
      "kmonad" = {
        source = lib.util.mkOutOfStoreSymlink "${configDir}/kmonad";
        recursive = true;
      };
    };
  };
}
