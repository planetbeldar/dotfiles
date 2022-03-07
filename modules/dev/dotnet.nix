{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) dotnet-sdk mono roslyn msbuild omnisharp-roslyn;

  cfg = config.modules.dev.dotnet;
in {
  options.modules.dev.dotnet = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      dotnet-sdk
      (omnisharp-roslyn.overrideAttrs
        (drv: {
          meta.platforms = drv.meta.platforms ++ lib.platforms.darwin;
        }))
    ];
  };
}
