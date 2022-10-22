{ pkgs, config, lib, ... }:
{
  # Modules
  modules = {
    shell = {
      aws.enable = true;
      bottom.enable = true;
      docker.enable = true;
      git.enable = true;
      openapi.enable = true;
      xkbswitch.enable = true;
      zsh.enable = true;
    };

    editors = {
      default       = "nvim";
      nvim.enable   = true;
      emacs.enable  = true;
    };

    dev = {
      dotnet.enable = true;
      haskell.enable = true;
      js.enable = true;
      kotlin.enable = true;
      postman.enable = true;
      qmk = {
        enable = true;
        home = "${config.user.home}/Projects/cpp";
        fork = "planetbeldar";
        branch = "planb";
      };
      rust.enable = true;
      yaml.enable = true;
      # zmk = {
      #   enable = true;
      #   home = "${config.user.home}/Projects/cpp";
      #   fork = "planetbeldar";
      # };
    };

    desktop = {
      yabai.enable  = true;
      skhd.enable   = true;
      kmonad.enable = true;

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
        discord.enable  = true;
        weechat.enable  = true;
      };

      media = {
        spotify.enable  = true;
        sonos.enable    = true;
        inkscape.enable = true;
      };

      vm = {
        qemu.enable = true;
      };

      db = {
        pgadmin.enable = true;
        dbeaver.enable = true;
      };
    };
  };
}
