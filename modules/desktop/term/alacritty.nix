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
    environment.systemPackages = [ alacritty ];

    home.configFile = {
      "alacritty" = {
        source = lib.util.mkOutOfStoreSymlink "${configDir}/alacritty";
        recursive = true;
      };
    };

    home.activation = mkIf stdenv.isDarwin {
      alacritty = hm.dag.entryAfter [ "writeBoundary" ] ''
        echo "Copying alacritty (${alacritty}) to system applications"
        $DRY_RUN_CMD sudo rm -fr /Applications/Alacritty.app
        $DRY_RUN_CMD cp --archive -H --dereference ${alacritty}/Applications/* /Applications
      '';
    };
  };
}
