{ options, config, lib, inputs, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (pkgs) stdenv slack;

  cfg = config.modules.desktop.social.slack;
in {
  options.modules.desktop.social.slack = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ slack ];
  };
}
