with (import <nixpkgs> {});
let
  pname = "spotify-mac";
  inherit pkgs;
in callPackage ./overlay.nix { inherit pname; }
