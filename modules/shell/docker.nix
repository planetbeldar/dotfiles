{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkEnableOption;
  inherit (pkgs) docker docker-compose docker-machine dockfmt;
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
    })
    (mkIf isLinux {
      environment.systemPackages = [
        docker
        docker-compose
        docker-machine
      ];

      # virtualisation = { docker.enable = true; };
    })
    {
      environment.systemPackages = [
        dockerfile-language-server-nodejs
        dockfmt
      ];
    }
  ]);
}
