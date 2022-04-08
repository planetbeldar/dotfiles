{ inputs, options, config, lib, pkgs, ... }:
with lib;
with inputs.home-manager.lib;
let
  inherit (pkgs) stdenv emacs emacsGcc;

  cfg = config.modules.editors.emacs;
  configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable (mkMerge [
    {
      nixpkgs.overlays = [ inputs.mac-overlay.overlays.emacs-mac ];
      # nix = {
      #   binaryCaches = [ "https://cachix.org/api/v1/cache/emacs" ];
      #   binaryCachePublicKeys =
      #     [ "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY=" ];
      # };

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
          sqlite #roam
        ] ++ lib.optionals stdenv.isDarwin [
          #emacs-macport
          gnugrep # pcre not enabled in macos version of grep
          emacs-mac
          # (emacsMacport.overrideAttrs (drv: {
          #   configureFlags = drv.configureFlags ++ [ "--with-no-title-bars" ];
          # }))
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
        "doom" = {
          source = lib.util.mkOutOfStoreSymlink "${configDir}/doom";
          recursive = true;
        };
      };

      env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
    }
  ]);
}
