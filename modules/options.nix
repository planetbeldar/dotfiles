{ config, options, lib, home-manager, pkgs, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (lib) util mkOption mapAttrs isList concatMapStringsSep elem concatStringsSep mapAttrsToList;
  inherit (lib.types) attrs path attrsOf oneOf str listOf package either;
  userPath = if isDarwin
             then "/Users"
             else "/home";
  stateVersion = "21.11";
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
    user =
      let user = builtins.getEnv "USER";
          name = if elem user [ "" "root" ] then "planetbeldar" else user;
      in {
        inherit name;
        description = "Primary user";
        home = "${userPath}/${name}";
      };

    home-manager = {
      # useGlobalPkgs = true; # both needed for pure mode?
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
          configFile = lib.mkAliasDefinitions options.home.configFile;
          dataFile   = lib.mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users.${config.user.name} = lib.mkAliasDefinitions options.user;

    nix = let users = [ "root" config.user.name ]; in {
      trustedUsers = users;
      allowedUsers = users;
    };

    env.PATH = [ "$PATH" ];

    environment.extraInit = concatStringsSep
      "\n" (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
