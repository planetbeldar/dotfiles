{ pkgs, config, lib, ... }:
{
  # Modules
  modules = {
    shell = {
      zsh.enable = true;
      m-cli.enable = true;
      git.enable = true;
      bottom.enable = true;
      xkbswitch.enable = true;
    };

    editors = {
      default       = "nvim";
      nvim.enable   = true;
      emacs.enable  = true;
    };

    dev = {
      dotnet.enable = true;
      haskell.enable = true;
      js.enable   = true;
      node.enable = true;
      qmk = {
        enable = true;
        home = "${config.user.home}/Projects/cpp";
        fork = "planetbeldar";
        branch = "planb";
      };
      yaml.enable = true;
    };

    desktop = {
      yabai.enable  = true;
      skhd.enable   = true;
      # kmonad.enable = true;

      term = {
        # default = "alacritty";
        alacritty.enable = true;
        kitty.enable = false;
        # xst.enable = true;
      };

      browsers = {
        vimari.enable = true;
        chrome.enable = true;
      #   default         = "safari";
      #   brave.enable    = true;
      #   firefox.enable  = true;
      #   chromium.enable = true;
      };

      social = {
        signal.enable   = true;
        #discord.enable  = true;
      };

      media = {
        spotify.enable  = true;
        sonos.enable    = true;
      };
    };
  };
}
