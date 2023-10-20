{ lib, pkgs, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) sqls postgresql leiningen;

  cfg = config.modules.dev.sql;
in {
  options.modules.dev.sql = {
    enable = mkEnableOption "SQL stuff";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      sqls
      postgresql

      #ejc-sql
      leiningen
    ];
  };
}
