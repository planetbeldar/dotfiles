{ config, options, lib, pkgs, ... }:
let
  inherit (lib) util types;
  cfg = config.modules.editors;
in {
  options.modules.editors = {
    default = util.mkOpt types.str "vim";
  };

  config = lib.mkIf (cfg.default != null) {
    env.EDITOR = cfg.default;
  };
}
