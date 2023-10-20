{ inputs, options, config, lib, pkgs, ... }:
let
  inherit (pkgs) stdenv emacs emacsMacport emacsNativeComp;
  inherit (lib) mkIf mkMerge mkEnableOption;

  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = { enable = mkEnableOption "enable emacs"; };

  config = mkIf cfg.enable (mkMerge [{
    # nixpkgs.overlays = [ inputs.mac-overlay.overlays.emacs-mac ];

    homebrew = {
      taps = [ "railwaycat/emacsmacport" ];
      brews = [{
        name = "railwaycat/emacsmacport/emacs-mac";
        args = [ "with-native-comp" "with-xwidgets" "with-tree-sitter" ];
      }];
    };

    # nixpkgs.config.allowBroken = true;

    environment.systemPackages = with pkgs;
      [
        git
        (ripgrep.override { withPCRE2 = true; })
        # coreutils
        fd
        # org-mode
        gnuplot
        # clang
        texlive.combined.scheme-medium
        sqlite # roam
        tree-sitter
        editorconfig-core-c
        (aspellWithDicts (dictionaries: with dictionaries; [
          sv en en-computers en-science
        ]))
      ] ++ lib.optionals stdenv.isDarwin [
        # emacs-macport
        # emacsMacport
        gnugrep # pcre not enabled in macos version of grep
        # local.emacs-mac
      ] ++ lib.optionals stdenv.isLinux [ emacsGcc ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    modules.shell.zsh.rcInit = ''
      EMACS_DIR=$XDG_CONFIG_HOME/emacs
      if [ ! -d "$EMACS_DIR" ]; then
        printf "Install and setup Doom Emacs to $EMACS_DIR? (y/n)"
        read -sk && echo

        if [[ "$REPLY" =~ ^[yY]$ ]]; then
          echo "Installing doom emacs into $EMACS_DIR"
          $DRY_RUN_CMD git clone git@github.com:hlissner/doom-emacs.git $EMACS_DIR
          $DRY_RUN_CMD $EMACS_DIR/bin/doom install
        fi
      fi
    '';

    home.configFile = {
      "doom".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/doom";
    };

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
  }]);
}
