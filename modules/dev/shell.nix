{ config, options, lib, pkgs, ... }:
let
  inherit (lib) util mkIf platforms;
  inherit (pkgs) shellcheck bashdb shfmt;
  inherit (pkgs.nodePackages) bash-language-server;

  cfg = config.modules.dev.shell;
in {
  options.modules.dev.shell = {
    enable = util.mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      shellcheck
      bash-language-server
      shfmt
      # not supported on macos, why?
      (bashdb.overrideAttrs
        (drv: { meta.platforms = drv.meta.platforms ++ platforms.darwin; }))
    ];
  };
}
