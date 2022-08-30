{ inputs, config, lib, pkgs, ... }:
let
  inherit (pkgs) stdenv;
  inherit (lib) util filterAttrs mapAttrsToList mapAttrs;
  traceImport = util.traceImportMsg "default.nix";
in {
  imports = (util.mapModulesRec' (toString ./modules) (traceImport));

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
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    unzip
    coreutils
    exa
    findutils #GNU find
    # diffutils #GNU diff
    pv
    ssh-copy-id
  ];
}
