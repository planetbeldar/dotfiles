{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) nixfmt;

  cfg = config.modules.dev.nix;
in {
  options.modules.dev.nix = {
    enable = util.mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = [
      nixfmt
    ];
  };
}
