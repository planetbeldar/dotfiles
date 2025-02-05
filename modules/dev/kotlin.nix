{ lib, pkgs, config, inputs, ... }:
let 
  inherit (lib) util types mkIf mkEnableOption;
  inherit (pkgs) fetchFromGitHub kotlin kotlin-language-server gradle ktlint;

  jdk = pkgs.openjdk21;
  cfg = config.modules.dev.kotlin;
in {
  options.modules.dev.kotlin = {
     enable = mkEnableOption "kotlin";
     xmx    = util.mkOpt types.str "8g";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
       kotlin
       kotlin-language-server
       gradle
       jdk
       ktlint
    ];

    env = {
      JAVA_HOME = "${jdk}";
      JAVA_OPTS = "-Xmx${cfg.xmx}";
    };
  };
}
