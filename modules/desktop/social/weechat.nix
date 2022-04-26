{ options, config, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (pkgs.weechatScripts) weechat-matrix;

  cfg = config.modules.desktop.social.weechat;
  weechat = pkgs.weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = [ weechat-matrix ];
      init = ''
      '';
    };
  };
in {
  options.modules.desktop.social.weechat = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    environment.systemPackages = [ weechat ];
  };
}
