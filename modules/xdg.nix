# xdg.nix
#
# Set up and enforce XDG compliance. Other modules will take care of their own,
# but this takes care of the general cases.

{ config, home-manager, lib, ... }:
let
  inherit (lib) mapAttrsToList concatStringsSep;

  exportVariables = variables:
    concatStringsSep "\n"
    (mapAttrsToList (n: v: ''export ${n}="${v}"'') variables);
in {
  ### A tidy $HOME is a tidy mind
  home-manager.users.${config.user.name} = { xdg.enable = true; };

  environment = {
    variables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_BIN_HOME = "$HOME/.local/bin";
    };
  };

  # initialize some variables later to be rid of race conditions
  env = {
    PATH = [ "$XDG_BIN_HOME" ];
    # Conform more programs to XDG conventions. The rest are handled by their
    # respective modules.
    __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    ASPELL_CONF = ''
      per-conf $XDG_CONFIG_HOME/aspell/aspell.conf;
      personal $XDG_CONFIG_HOME/aspell/en_US.pws;
      repl $XDG_CONFIG_HOME/aspell/en.prepl;
    '';
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    HISTFILE = "$XDG_DATA_HOME/bash/history";
    INPUTRC = "$XDG_CONFIG_HOME/readline/inputrc";
    LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    # WGETRC = "$XDG_CONFIG_HOME/wgetrc";
  };
}
