{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) terraform terraform-ls;

  cfg = config.modules.dev.terraform;
in {
  options.modules.dev.terraform = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      terraform
      terraform-ls
    ];
  };
}
