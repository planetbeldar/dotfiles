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
      default       = "nvim";
      nvim.enable   = true;
      emacs.enable  = true;
    };

    dev = {
      # dotnet.enable = true;
      node.enable = true; # must enable nodejs package to *use* packages installed via nodePackages namespace?
      yaml.enable = true;
      qmk = {
        enable = true;
        home = "${config.user.home}/Projects/cpp";
        fork = "planetbeldar";
        branch = "planb";
      };
    };

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
