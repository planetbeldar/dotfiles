{ pkgs, config, lib, ... }:
{
  # Modules
  modules = {
    shell = {
      zsh.enable = true;
      m-cli.enable = true;
      git.enable = true;
      bottom.enable = true;
    };

    editors = {
      nvim.enable   = true;
      default       = "nvim";
      emacs.enable  = true;
    };

    # dev = {
      # node.enable = true;
      # dotnet.enable = true;
    # };

    desktop = {
      yabai.enable  = true;
      skhd.enable   = true;

      term = {
        # default = "kitty";
        alacritty.enable = true;
        # kitty.enable = true;
        # xst.enable = true;
      };

      browsers = {
        vimari.enable = true;
      #   default         = "safari";
      #   brave.enable    = true;
      #   firefox.enable  = true;
      #   chromium.enable = true;
      };

      social = {
        signal.enable   = true;
        discord.enable  = true;
      };

      # media = {
      #   spotify.enable  = true;
      #   sonos.enable    = true;
      # };
    };
  };
}
