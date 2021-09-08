{ inputs, lib, pkgs, darwin, ... }:

let
  inherit (lib) makeExtensible attrValues foldr;
  inherit (modules) mapModules;

  traceImport = p: args: import (lib.trace "lib/default.nix: import ${p}" p) args;

  modules = traceImport ./modules.nix {
    inherit lib;
    self.attrs = traceImport ./attrs.nix { inherit lib; };
  };

  util = makeExtensible (self:
    with self; mapModules ./.
      (file: traceImport file { inherit self lib pkgs inputs darwin; }));
in
util.extend
  (self: super:
    foldr (a: b: a // b) {} (attrValues super))
