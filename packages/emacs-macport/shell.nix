with (import <nixpkgs> {});
let
  inherit pkgs;
in callPackage ./default.nix {}
