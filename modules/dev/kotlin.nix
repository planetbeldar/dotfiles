{ lib, pkgs, config, ... }:
let 
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) fetchFromGitHub kotlin kotlin-language-server gradle;

  kotlin-ls = kotlin-language-server.overrideAttrs(drv: {
    version = "unstable-2022-10-17";
    src = fetchFromGitHub {
      owner = "fwcd";
      repo = "kotlin-language-server";
      rev = "cf5fda0d0a4ce86835b49d4856a32bec52a514d6";
      sha256 = "1HHa3rOwl7lWxh5BG3U0Dy/9wnmZGWPv1LqOHUHkZ1g=";
    };

    # nativeBuildInputs = drv.nativeBuildInputs ++ [ pkgs.jdk11 ];

    dontBuild = false;

    buildPhase = ''
      rm -fr .gradle
      ${gradle}/bin/gradle :server:installDist
      cp -r server/build/install/server/{bin,lib} .
    '';
  });

  cfg = config.modules.dev.kotlin;
in {
  options.modules.dev.kotlin = {
     enable = mkEnableOption "enable kotlin";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
       kotlin
       kotlin-language-server
       # kotlin-ls
       gradle
    ];
  };
}
