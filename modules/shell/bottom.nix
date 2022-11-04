{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkIf util;
  # inherit (pkgs) bottom;

  cfg = config.modules.shell.bottom;
  configDir = config.dotfiles.configDir;
  bottom = pkgs.bottom.overrideAttrs(drv: rec {
    version = "2022-11-04";

    src = pkgs.fetchFromGitHub {
      owner = "ClementTsang";
      repo = drv.pname;
      rev = "6f95aaee34f7f9bfd49a4ebabfdce8dff76e03c0";
      sha256 = "sha256-MWyYMBu5JxLdJZSTKMa/uqYGUcj4KbfPJzDWdVob/VM=";
    };

    cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
      inherit src;
      outputHash = "sha256-AIPWqOW5p8AXfaH0hOucUTgP8aeuRS4vS5jEqEGtkRc=";
      # outputHash = lib.fakeHash;
    });
  });
in {
  options.modules.shell.bottom = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ bottom ];

    home.configFile = {
      "bottom" = {
        source = "${configDir}/bottom";
        recursive = true;
      };
    };
  };
}
