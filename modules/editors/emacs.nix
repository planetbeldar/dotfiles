{ inputs, options, config, lib, pkgs, ... }:
with lib;
with inputs.home-manager.lib;
let
  inherit (pkgs.stdenv) isDarwin;

  inherit (pkgs) emacs emacsGcc;
  #inherit (pkgs.local) emacs-macport;

  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nixpkgs.overlays = [ inputs.emacs.overlay ];
      nix = {
        binaryCaches = [ "https://cachix.org/api/v1/cache/emacs" ];
        binaryCachePublicKeys = [ "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY=" ];
      };

      environment.systemPackages = with pkgs; [
        git
        ripgrep
        coreutils
        fd
        # org-mode
        gnuplot
        clang
        texlive.combined.scheme-medium
      ]
      ++ lib.optionals (isDarwin) [
        #emacs-macport
        emacs
      ]
      ++ lib.optionals (!isDarwin) [
        emacsGcc
      ];

      fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

      modules.shell.zsh.rcInit = ''
        EMACS_DIR=$XDG_CONFIG_HOME/emacs
        if [ ! -d $EMACS_DIR ]; then
          echo "Installing doom emacs into $EMACS_DIR"
          git clone git@github.com:hlissner/doom-emacs.git $EMACS_DIR
          $EMACS_DIR/bin/doom install
        fi
      '';

      home.configFile = {
        "doom" = { source = "${configDir}/doom"; recursive = true; };
      };

      env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
    }
    (mkIf isDarwin {
      home.activation.emacs = hm.dag.entryAfter["writeBoundary"] ''
        echo "Copying emacs (${emacs.out}) to system applications"
        $DRY_RUN_CMD sudo rm -fr /Applications/Emacs.app
        $DRY_RUN_CMD cp $VERBOSE_ARG -r ${emacs}/Applications/Emacs.app /Applications
      '';
    })
  ]);
}
