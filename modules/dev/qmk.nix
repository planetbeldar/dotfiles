{ inputs, config, options, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (lib.types) path str;
  inherit (pkgs) stdenv qmk;

  cfg = config.modules.dev.qmk;
in {
  options.modules.dev.qmk = {
    enable = util.mkBoolOpt false;
    home = util.mkOpt' path "${config.user.home}" "QMK_HOME parent directory";
    fork = util.mkOpt' str "qmk" "Fork of QMK firmware";
    branch = util.mkOpt' str "master" "Branch to use with QMK firmware";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.mac-overlay.overlays.qmk-toolbox ];
    environment.systemPackages = [ qmk ]
      ++ lib.optionals stdenv.isDarwin [ pkgs.qmk-toolbox ];

    environment.variables = { QMK_HOME = "${cfg.home}/qmk_firmware"; };

    modules.shell.zsh.rcInit = ''
      if [ ! -d "$QMK_HOME" ]; then
        printf "Install and setup QMK to $QMK_HOME? (y/N)"
        read -sk && echo

        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
          $DRY_RUN_CMD git clone --recurse-submodules --branch ${cfg.branch} git@github.com:${cfg.fork}/qmk_firmware.git $QMK_HOME
          $DRY_RUN_CMD git -C $QMK_HOME remote add upstream git@github.com:qmk/qmk_firmware.git
        fi
      fi
    '';
  };
}
