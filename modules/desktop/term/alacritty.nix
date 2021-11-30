{ inputs, options, config, lib, pkgs, ... }:
with inputs.home-manager.lib;
let
  inherit (lib) util mkIf;
  inherit (pkgs) stdenv;
  inherit (inputs.home-manager.lib) hm;

  cfg = config.modules.desktop.term.alacritty;
  configDir = config.dotfiles.configDir;

  alacritty = if stdenv.isDarwin then pkgs.alacritty-mac else pkgs.alacritty;
in {
  options.modules.desktop.term.alacritty = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.alacritty-mac ];
    environment.systemPackages = [ alacritty ];

    home.configFile = {
      "alacritty" = {
        source = lib.util.mkOutOfStoreSymlink "${configDir}/alacritty";
        recursive = true;
      };
    };
  };
}
