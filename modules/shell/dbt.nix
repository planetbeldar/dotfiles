{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.shell.dbt;
  dbt = pkgs.dbt.withAdapters (adapters: with adapters; [
    dbt-bigquery dbt-postgres dbt-redshift dbt-snowflake
  ]);
in {
  options.modules.shell.dbt = { enable = mkEnableOption "enable dbt cli"; };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      dbt
    ];

    env = {
      DBT_PROFILES_DIR = "$XDG_CONFIG_HOME/dbt";
    };
  };
}
