{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) ghc haskell-language-server cabal-install;
  inherit (pkgs.haskellPackages) ghcup hoogle;

  cfg = config.modules.dev.haskell;
in {
  options.modules.dev.haskell = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cabal-install
      ghc
      ghcup
      hoogle
      haskell-language-server
    ];

    env = {
      GHCUP_USE_XDG_DIRS  = "true";
      CABAL_CONFIG        = "$XDG_CONFIG_HOME/cabal/config";
      CABAL_DIR           = "$XDG_DATA_HOME/cabal";
    };
  };
}
