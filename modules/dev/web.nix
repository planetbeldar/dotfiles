{ config, options, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkMerge;
  inherit (pkgs) stdenv nodejs yarn;
  inherit (pkgs.nodePackages_latest)
    vscode-langservers-extracted typescript-language-server typescript
    stylelint js-beautify eslint prettier;

  cfg = config.modules.dev.web;
in {
  options.modules.dev.web = {
    enable = mkEnableOption "enable JS, TS, HTML, JSON...";
    nvm = mkEnableOption "setup nvm (darwin only)";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [
        nodejs
        yarn

        eslint
        prettier
        vscode-langservers-extracted #https://github.com/hrsh7th/vscode-langservers-extracted
        typescript-language-server
        typescript
        stylelint
        js-beautify
      ];
    }
    (mkIf (stdenv.isDarwin && cfg.nvm) {
      homebrew.brews = lib.optionals cfg.nvm [ "nvm" ];

      env.NVM_DIR = "$XDG_CONFIG_HOME/nvm";

      modules.shell.zsh.rcInit = ''
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
        [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
      '';
    })
  ]);

}
