{ config, options, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (pkgs) neovim;

  cfg = config.modules.editors.nvim;
in {
  options.modules.editors.nvim = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      neovim
    ];
  };
}
