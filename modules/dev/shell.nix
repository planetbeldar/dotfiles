{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) shellcheck bashdb nodePackages;

  cfg = config.modules.dev.shell;
in {
  options.modules.dev.shell = {
    enable = util.mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = [
      shellcheck
      # not supported on macos, why?
      (bashdb.overrideAttrs (lib.const {
        meta.platforms = lib.platforms.unix;
      }))
      nodePackages.bash-language-server
    ];
  };
}
