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
      tmux.enable = true;
      _1password = {
        enable = true;
        gui = true;
      };
    };

    editors = {
      default       = "nvim";
      nvim.enable   = true;
      emacs.enable  = true;
    };

    dev = {
      dotnet.enable = true;
      haskell.enable = true;
      web.enable = true;
      web.nvm = true;
      kotlin.enable = true;
      postman.enable = true;
      qmk = {
        enable = false;
        home = "${config.user.home}/Projects/cpp";
        fork = "planetbeldar";
        branch = "planb";
      };
      rust.enable = true;
      yaml.enable = true;
      nginx.enable = true;
      mjml.enable = true;
      ngrok.enable = true;
      sql.enable = true;
      terraform.enable = true;
    };

    desktop = {
      yabai.enable  = true;
      skhd.enable   = true;
      kmonad.enable = false;

      term = {
        # default = "alacritty";
        alacritty.enable = true;
        kitty.enable = false;
        # xst.enable = true;
      };

      browsers = {
        vimari.enable = true;
        chrome.enable = true;
      };

      ide = {
        idea.enable = true;
        # fleet.enable = true;
      };

      social = {
        discord.enable  = true;
        signal.enable   = true;
        slack.enable    = true;
        weechat.enable  = false;
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
