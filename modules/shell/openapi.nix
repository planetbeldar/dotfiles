{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) fetchurl;
  # inherit (pkgs) openapi-generator-cli;

  cfg = config.modules.shell.openapi;
  openapi-generator-cli = let
    version = "6.0.0";
    pname = "openapi-generator-cli";
    jarfilename = "${pname}-${version}.jar";
  in pkgs.openapi-generator-cli.overrideAttrs (drv: {
    inherit version pname;
    src = fetchurl {
      url = "mirror://maven/org/openapitools/${pname}/${version}/${jarfilename}";
      sha256 = "DLimlQ/JuMag4WGysYJ/vdglNw6nu0QP7vDT66LEKT4=";
    };
  });
in {
  options.modules.shell.openapi = {
    enable = mkEnableOption "enable openapi generator";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = [ openapi-generator-cli ]; };
}
