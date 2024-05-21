{ config, options, lib, home-manager, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) util mkOption mapAttrs isList concatMapStringsSep elem concatStringsSep mapAttrsToList;
  inherit (lib.types) attrs path attrsOf oneOf str listOf package either;

  stateVersion = "22.05";
  userPath = if isDarwin
             then "/Users"
             else "/home";
in {
  options = {
    user = util.mkOpt attrs {};

    dotfiles = {
      dir         = util.mkOpt path "${config.user.home}/.config/dotfiles";
      configDir   = util.mkOpt path "${config.dotfiles.dir}/config";
      modulesDir  = util.mkOpt path "${config.dotfiles.dir}/modules";
    };

    home = {
      file       = util.mkOpt' attrs {} "Files to place directly in $HOME";
      configHome = util.mkOpt' path "${config.user.home}/.config" "$XDG_CONFIG_HOME, defaults to $HOME/.config";
      configFile = util.mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile   = util.mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";

      activation = util.mkOpt' attrs {} "Activation scripts";
      packages   = util.mkOpt' (listOf package) [] "Packages";
    };

    env = mkOption {
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      apply = mapAttrs
        (n: v: if isList v
               then concatMapStringsSep ":" (x: toString x) v
               else (toString v));
      default = {};
      description = "Environment variables.";
    };
  };

  config = {
    # make home-manager's mkOutOfStoreSymlink accessible outside of its module
    lib.file.mkOutOfStoreSymlink = config.home-manager.users.${config.user.name}.lib.file.mkOutOfStoreSymlink;

    user =
      let user = builtins.getEnv "USER";
          name = if elem user [ "" "root" ] then "planetbeldar" else user;
      in {
        inherit name;
        description = "Primary user";
        home = "${userPath}/${name}";
      };

    home-manager = {
      useGlobalPkgs = true; # both needed for pure mode?
      useUserPackages = true;
      verbose = false;

      users.${config.user.name} = {
        home = {
          inherit stateVersion;
          homeDirectory = config.user.home;

          file = lib.mkAliasDefinitions options.home.file;
          activation = lib.mkAliasDefinitions options.home.activation;
          packages = lib.mkAliasDefinitions options.home.packages;
        };
        xdg = {
          configHome = lib.mkAliasDefinitions options.home.configHome;
          configFile = lib.mkAliasDefinitions options.home.configFile;
          dataFile   = lib.mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users.${config.user.name} = lib.mkAliasDefinitions options.user;

    nix.settings = let users = [ "root" config.user.name ]; in {
      trusted-users = users;
      allowed-users = users;
    };

    env.PATH = (lib.optionals isDarwin [ "/opt/homebrew/bin" ]) ++ [ "$PATH" ];

    environment.extraInit = concatStringsSep
      "\n" (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);

  };
}
