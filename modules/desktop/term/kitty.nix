{ options, config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.term.kitty;
in {
  options.modules.desktop.term.kitty = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = xst-256color ] && export TERM=xterm-256color
    '';

    environment.systemPackages = with pkgs; [ kitty ];
  };
}
