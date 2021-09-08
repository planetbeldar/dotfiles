{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.editors.nvim;
in {
  options.modules.editors.nvim = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neovim
    ];
  };
}
