{ options, config, inputs, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;

  cfg = config.modules.desktop.kmonad;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.kmonad = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.kmonad-mac ];

    # make kmonad link to bin
    # - so we dont need to reallow in mac privacy settings when nix store location changes
    environment.systemPackages = [ pkgs.kmonad-mac ];

    services.kmonad-mac = {
      enable = true;
      package = pkgs.kmonad-mac;
      keymap = "${config.home.configHome}/kmonad/config.kbd";
    };

    home.configFile = {
      "kmonad" = {
        source = lib.util.mkOutOfStoreSymlink "${configDir}/kmonad";
        recursive = true;
      };
    };
  };
}
