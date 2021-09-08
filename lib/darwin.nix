{ inputs, lib, pkgs, darwin, ... }:
with lib;
let
  sys = "x86_64-darwin";
  traceImport = util.traceImportMsg "lib/darwin.nix:";
in {
  mkDarwinHost = path: attrs @ { system ? sys, ... }:
    darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      inputs = { inherit darwin system pkgs lib; };
      modules = [
        {
          homebrew = {
            enable = true;
            global.brewfile = true;
            global.noLock = true;
          };

          nixpkgs.overlays = pkgs.overlays;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        inputs.home-manager.darwinModules.home-manager
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        (traceImport ../.)   # /default.nix
        (traceImport path)
      ];
    };

  mapDarwinHosts = dir: attrs @ { ... }:
    util.mapModules dir
      (hostPath: util.mkDarwinHost hostPath attrs);
}
