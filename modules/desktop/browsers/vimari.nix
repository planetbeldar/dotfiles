{ inputs, config, options, lib, pkgs, ... }:

with lib;
with inputs.home-manager.lib;
let
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.modules.desktop.browsers.vimari;
  configDir = config.dotfiles.configDir;

  safariSetting = "$HOME/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist";
  vimariSetting = "net.televator.Vimari.SafariExtension (Y48UDGWSSQ)";
  abpSetting = "org.adblockplus.adblockplussafarimac.AdblockPlusSafariToolbar (GRYYZR985A)";
  extensionList = "$HOME/Library/Containers/com.apple.Safari/Data/Library/Safari/AppExtensions/Extensions.plist";
in {
  options.modules.desktop.browsers.vimari = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf (cfg.enable && isDarwin) {
    homebrew.masApps = {
      Vimari = 1480933944;
      "AdBlock Plus for Safari ABP" = 1432731683;
    };

    home.activation.safari = hm.dag.entryAfter ["writeBoundary"] ''
      echo "Setting Safari (Vimari) shortcut(s)"
      $DRY_RUN_CMD sudo rm -f ${safariSetting}
      $DRY_RUN_CMD defaults write ${safariSetting} NSUserKeyEquivalents -dict-add "Open Location..." "o"
    '';

    home.activation.vimari = hm.dag.entryAfter ["writeBoundary"] ''
      echo "Copying vimari user settings as it cannot be a symlink."
      $DRY_RUN_CMD cp -a ${configDir}/vimari/userSettings.json $HOME/Library/Containers/net.televator.Vimari.SafariExtension/Data/Library/Application\ Support

      echo "Enabling Safari extension: Vimari"
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Add :'${vimariSetting}':Enabled bool true" ${extensionList} 2> /dev/null \
      || $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :'${vimariSetting}':Enabled true" ${extensionList}
    '';

    home.activation.abp = hm.dag.entryAfter ["writeBoundary"] ''
      echo "Enabling Safari extension: ABP"
      $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Add :'${abpSetting}':Enabled bool true" ${extensionList} 2> /dev/null \
      || $DRY_RUN_CMD /usr/libexec/PlistBuddy -c "Set :'${abpSetting}':Enabled true" ${extensionList}
    '';
  };
}
