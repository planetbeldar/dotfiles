{ inputs, lib, pkgs, ... }:
let
  inherit (lib) escapeShellArg;
  inherit (inputs.home-manager.lib) hm;
in {
  mkOutOfStoreSymlink = path:
    let
      pathStr = toString path;
      name = hm.strings.storeFileName (baseNameOf pathStr);
    in
      pkgs.runCommandLocal name {} ''ln -s ${escapeShellArg pathStr} $out'';
}
