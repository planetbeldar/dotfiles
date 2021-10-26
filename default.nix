{ inputs, config, lib, pkgs, ... }:
with lib;
let
  inherit (pkgs.stdenv) isDarwin;
  traceImport = util.traceImportMsg "default.nix";
in
{
  imports =
    # [ inputs.home-manager.darwinModules.home-manager ] ++
    (util.mapModulesRec' (toString ./modules) (traceImport));

  # Common config for all nix machines; and to ensure the flake operates soundly
  environment.variables.DOTFILES = config.dotfiles.dir;
  # environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix =
    let
      filteredInputs = filterAttrs (n: _: n != "self") inputs;
      nixPathInputs  = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
      registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in {
      package = pkgs.nixUnstable;
      extraOptions = ''experimental-features = nix-command flakes'';
      useDaemon = true;
      nixPath = nixPathInputs ++ [
        "dotfiles=${config.dotfiles.dir}"
      ];
      binaryCaches = [
        "https://nix-community.cachix.org"
      ];
      binaryCachePublicKeys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    unzip
    coreutils
  ];
}
