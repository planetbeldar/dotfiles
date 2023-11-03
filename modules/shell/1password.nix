{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.shell._1password;
in {
  options.modules.shell._1password = {
    enable = mkEnableOption "enable 1password cli";
    gui = mkEnableOption "install gui app";
  };

  config = mkIf cfg.enable {
      environment.systemPackages = with pkgs;
        [
          _1password
        ] ++ lib.optionals cfg.gui [
          _1password-gui
        ];
  };
}
