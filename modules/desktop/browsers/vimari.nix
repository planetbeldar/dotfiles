{ inputs, config, options, lib, pkgs, ... }:

with lib;
with inputs.home-manager.lib;
let
  inherit (pkgs.stdenv) isDarwin;
  cfg = config.modules.desktop.browsers.vimari;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.browsers.vimari = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf (cfg.enable && isDarwin) {
    homebrew.masApps = {
      Vimari = 1480933944;
    };

    home.activation.vimari = hm.dag.entryAfter ["writeBoundary"] ''
      echo "Copying vimari user settings as it cannot be a symlink."
      $DRY_RUN_CMD cp -a ${configDir}/vimari/userSettings.json $HOME/Library/Containers/net.televator.Vimari.SafariExtension/Data/Library/Application\ Support
    '';

    home.activation.safari = hm.dag.entryAfter ["writeBoundary"] ''
      SAFARI_SETTINGS="$HOME/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist"

      echo "Setting Safari (Vimari) shortcut(s)."
      $DRY_RUN_CMD sudo rm -f $SAFARI_SETTINGS
      $DRY_RUN_CMD defaults write $SAFARI_SETTINGS NSUserKeyEquivalents -dict-add "Open Location..." "o"

      echo "Enabling Safari extension: Vimari."
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :'net.televator.Vimari.SafariExtension (Y48UDGWSSQ)':Enabled true" $HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/AppExtensions/Extensions.plist
    '';
  };

  # Copy vimari settings file, cannot be a symlink!
  # Use post activation script?

  # update safari shortcut:
  # SAFARI_SETTINGS="$HOME/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist"
  # echo Setting Safari (Vimari) shortcut(s).
  # rm -f $SAFARI_SETTINGS
  # defaults write $SAFARI_SETTINGS NSUserKeyEquivalents -dict-add "Open Location..." "o"

  # TODO
  # - Is there any way to activate Vimari extension from cli?
  # - Set more general settings for Safari (not just shortcuts)
  #   defaults everything!
}
