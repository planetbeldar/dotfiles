{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) fetchFromGitHub;

  cfg = config.modules.dev.aws;
  awscli2 = pkgs.awscli2.overrideAttrs (drv: rec {
    version = "2.7.1";
    name = "${drv.pname}-${version}";
    src = fetchFromGitHub {
      owner = "aws";
      repo = "aws-cli";
      rev = version;
      sha256 = "riwbCeHNv3KE3b79N9swnWi9p2cZzNqJVwHBaAeV7Lo=";
    };
  });
in {
  options.modules.dev.aws = { enable = mkEnableOption "enable aws cli"; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ awscli2 ];

    env = {
      AWS_CONFIG_FILE = "$XDG_CONFIG_HOME/aws/config";
      AWS_SHARED_CREDENTIALS_FILE = "$XDG_CONFIG_HOME/aws/credentials";
      AWS_DATA_PATH = "$XDG_DATA_HOME/aws/models";
    };
  };
}
