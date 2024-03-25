{ inputs, lib, pkgs, ... }:
let
  inherit (lib) util mkDefault removeSuffix filterAttrs elem;
  inherit (inputs) darwin home-manager;
  inherit (pkgs) stdenv;

  traceImport = util.traceImportMsg "lib/darwin.nix:";
in {
  mkDarwinHost = path: attrs @ { system ? stdenv.hostPlatform.system, ... }:
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit lib inputs; };
      modules = [
        home-manager.darwinModule
        {
          homebrew = {
            enable = true;
            global.autoUpdate = true;
            global.brewfile = true;
            global.lockfiles = false;
          };

          nixpkgs.config = pkgs.config;
          nixpkgs.overlays = pkgs.overlays;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        inputs.mac-overlay.modules.kmonad-mac
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        (traceImport ../.)   # /default.nix
        (traceImport path)
      ];
    };

  mapDarwinHosts = dir: attrs @ { ... }:
    util.mapModules dir
      (hostPath: util.mkDarwinHost hostPath attrs);
}
