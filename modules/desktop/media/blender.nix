{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf mkEnableOption;
  inherit (pkgs) stdenv blender;

  cfg = config.modules.desktop.media.blender;
in
{
  options.modules.desktop.media.blender = {
    enable = mkEnableOption "enable blender";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = lib.optionals stdenv.isLinux [ blender ];

    homebrew.casks = lib.optionals stdenv.isDarwin [ "blender" ];
  };
}
