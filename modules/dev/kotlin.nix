{ lib, pkgs, config, inputs, ... }:
let 
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) fetchFromGitHub kotlin kotlin-language-server gradle ktlint;

  jdk = pkgs.openjdk19;
  kotlin-ls = kotlin-language-server.overrideAttrs(drv: {
    version = "1.3.7";
  });

  cfg = config.modules.dev.kotlin;
in {
  options.modules.dev.kotlin = {
     enable = mkEnableOption "enable kotlin";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
       kotlin
       # kotlin-language-server
       kotlin-ls
       gradle
       jdk
       ktlint
    ];

    env = {
      JAVA_HOME = "${jdk}";
      KOTLIN_LANGUAGE_SERVER_OPTS = "-Xmx16g";
    };
  };
}
