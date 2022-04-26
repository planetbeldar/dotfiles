{ inputs, lib, pkgs, darwin, ... }:
let
  inherit (lib) util mkDefault removeSuffix filterAttrs elem;
  inherit (pkgs) stdenv;

  traceImport = util.traceImportMsg "lib/darwin.nix:";
in {
  mkDarwinHost = path: attrs @ { system ? stdenv.hostPlatform.system, ... }:
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

          nixpkgs.config = pkgs.config;
          nixpkgs.overlays = pkgs.overlays;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        inputs.home-manager.darwinModule
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
