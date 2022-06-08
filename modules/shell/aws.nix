{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) awscli2;

  cfg = config.modules.shell.aws;
in {
  options.modules.shell.aws = { enable = mkEnableOption "enable aws cli"; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ awscli2 ];

    env = {
      AWS_CONFIG_FILE = "$XDG_CONFIG_HOME/aws/config";
      AWS_SHARED_CREDENTIALS_FILE = "$XDG_CONFIG_HOME/aws/credentials";
      AWS_DATA_PATH = "$XDG_DATA_HOME/aws/models";
    };
  };
}
