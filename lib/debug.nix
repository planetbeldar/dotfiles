{ lib, pkgs, ... }:
let
  inherit (lib) trace traceVal;
in rec {
  traceFn = fn: msg: p: fn (trace "${msg} ${p}" p);
  traceImportMsg = msg: p: import (trace (msg + " import ${p}") p);
  traceImport = traceFn import "import";
  traceCallPackageMsg = msg: p: pkgs.callPackage (trace "${msg} callPackage ${p}" p) {};
}
