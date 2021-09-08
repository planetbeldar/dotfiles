{ inputs, lib, pkgs, ... }:
with lib;
let
  sys = "x86_64-linux";
  traceImport = util.traceImportMsg "lib/nixos.nix:";
in {
  mkNixosHost = path: attrs @ { system ? sys, ... }:
    lib.nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          nixpkgs.overlays = pkgs.overlays;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        (traceImport ../.)   # /default.nix
        (traceImport path)
      ];
    };

  mapNixosHosts = dir: attrs @ { ... }:
    util.mapModules dir
      (hostPath: util.mkNixosHost hostPath attrs);
}
