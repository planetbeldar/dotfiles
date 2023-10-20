{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkEnableOption;
  inherit (pkgs) docker docker-compose docker-machine;
  inherit (pkgs.nodePackages) dockerfile-language-server-nodejs;
  inherit (pkgs.stdenv) isDarwin isLinux;

  cfg = config.modules.shell.docker;
in {
  options.modules.shell.docker = { enable = mkEnableOption "enable docker"; };

  config = mkIf cfg.enable (mkMerge[
    (mkIf isDarwin {
      homebrew = {
        casks = [{
          name = "docker";
        }];
      };

      environment.systemPackages = [
        dockerfile-language-server-nodejs
      ];
    })
    (mkIf false {
      environment.systemPackages = [
        docker
        docker-compose
        docker-machine
        dockerfile-language-server-nodejs
      ];

      # virtualisation = { docker.enable = true; };
    })
  ]);
}
