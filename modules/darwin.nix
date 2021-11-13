{ options, config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkForce;
  inherit (pkgs) stdenv;
in {
  config = mkIf stdenv.isDarwin {
    # Copy mac applications installed via Nix to $HOME so Spotlight can index them
    system.activationScripts.applications.text = mkForce (''
      IFS=$'\n'
      hashApp() {
        path="$1/Contents/MacOS/"; shift
        find -s "$path" -perm +111 -type f -maxdepth 1 -exec sh -c "md5sum {} | cut -b-32" \; 2> /dev/null || true \
          | md5sum | cut -b-32
      }
      mkdir -p $HOME/Applications/
      echo "Looking for mac apps in ${config.system.build.applications}"
      for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        name="$(basename "$app")"
        src="$(/usr/bin/stat -f%Y "$app")"
        dst="$HOME/Applications/$name"
        hash1="$(hashApp "$src")"
        hash2="$(hashApp "$dst")"

        printf " Found '$name'"
        if [ "$hash1" != "$hash2" ]; then
          printf " and its hash differs from the store, copying.."
          $DRY_RUN_CMD cp --archive -H --dereference "$src" $HOME/Applications
          printf " done.\n"
        else
          printf " and it's up to date with the store.\n"
        fi
      done
    '');
  };
}
