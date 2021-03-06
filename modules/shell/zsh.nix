{ config, options, pkgs, lib, ... }:
let
  inherit (lib) util mkEnableOption mkIf mapAttrsToList concatStringsSep concatMapStrings;
  inherit (pkgs) zsh neofetch colordiff fetchFromGitHub;

  cfg = config.modules.shell.zsh;
  configDir = config.dotfiles.configDir;

  zsh-prezto = pkgs.zsh-prezto.overrideAttrs (drv: {
    version = "unstable-2022-04-11";
    src = fetchFromGitHub {
      owner = "sorin-ionescu";
      repo = "prezto";
      rev = "dea85a0740253c0e17fa7eadb067694e11f5451c";
      sha256 = "5vfwFGTOj0swo88MmRSF3LHH1GusBZdsDfHiTSBSWDA=";
      fetchSubmodules = true;
    };

    postPatch = drv.postPatch + ''
      rm -fr .git* .editorconfig
    '';
  });
in {
  options.modules.shell.zsh = with lib.types; {
    enable = mkEnableOption "enable zsh";

    aliases = util.mkOpt (attrsOf (either str path)) { };

    rcInit = util.mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and sourced by
      $XDG_CONFIG_HOME/zsh/.zshrc
    '';
    envInit = util.mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshenv and sourced
      by $XDG_CONFIG_HOME/zsh/.zshenv
    '';

    rcFiles = util.mkOpt (listOf (either str path)) [ ];
    envFiles = util.mkOpt (listOf (either str path)) [ ];
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
    };

    environment.systemPackages = [
      zsh
      zsh-prezto
      neofetch
      # used by prezto
      colordiff
    ];

    env = {
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
      # ZPREZTODIR = "${zsh-prezto}/share/zsh-prezto"; # running init from the nix store is sooo slow..
      ZPREZTODIR = "$XDG_DATA_HOME/zprezto"; # this makes prezto start much faster, why?
    };

    home.configFile = {
      # Write it recursively so other modules can write files to it
      "zsh" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/zsh";
        recursive = true;
      };

      # Why am I creating extra.zsh{rc,env} when I could be using extraInit?
      # Because extraInit generates those files in /etc/profile, and mine just
      # write the files to ~/.config/zsh; where it's easier to edit and tweak
      # them in case of issues or when experimenting.
      "zsh/extra.zshrc".text = let
        aliasLines = mapAttrsToList (n: v: ''alias ${n}="${v}"'') cfg.aliases;
      in ''
        # Autogenerated file, do not edit.
        ${concatStringsSep "\n" aliasLines}
        ${concatMapStrings (path: ''
          source '${path}'
        '') cfg.rcFiles}
        ${cfg.rcInit}
      '';

      "zsh/extra.zshenv".text = ''
        # Autogenerated file, do not edit.
        ${concatMapStrings (path: ''
          source '${path}'
        '') cfg.envFiles}
        ${cfg.envInit}
      '';
    };

    home.dataFile = {
      zprezto.source = "${zsh-prezto}/share/zsh-prezto";
    };
  };
}
