{ options, config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkForce;
  inherit (pkgs) stdenv rsync gnugrep;
in {
  config = mkIf stdenv.isDarwin {

    homebrew.casks = [
      "cursr"
    ];

    # Sync mac applications installed via Nix to users home
    system.activationScripts.applications.text = mkForce (''
      syncApp() {
        local src="$1"
        local dst="$2"
        ${rsync}/bin/rsync -aLci "$src" "$dst" | ${gnugrep}/bin/grep -c ">f" || true
      }

      applications="${config.system.build.applications}"
      home="${config.user.home}"

      mkdir -p "$home/Applications/"
      echo "Looking for mac apps in $applications"

      find "$applications"/Applications/* -maxdepth 1 -type l |
      while read -r app; do
        name=$(basename "$app")
        printf " Found %s" "$name"

        src=$(/usr/bin/stat -f%Y "$app")
        dst="$home/Applications/$name"

        printf " - Synchronizing..\r"
        changes=$(syncApp "$src" "$home/Applications/")
        if [[ "$changes" -ne 0 ]]; then
          printf "%-40s -> Updated %s file(s)\n" "$name" "$changes"
        else
          printf "%-40s -> Up to date\n" "$name"
        fi
      done
    '');
  };
}
