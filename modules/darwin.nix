{ options, config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkForce;
  inherit (lib.strings) concatStringsSep;
  inherit (pkgs) stdenv rsync gnugrep;

  # Some apps requires to be run from /Applications :(
  rootApplications = map (x: x + ".app") [
    ".Karabiner-VirtualHIDDevice-Manager"
    "1Password"
  ];
in {
  config = mkIf stdenv.isDarwin {

    homebrew.casks = [
      "cursr"
    ];

    # Sync mac applications installed via Nix to root or users home
    system.activationScripts.applications.text = mkForce (''
      home() {
        local name="$1"
        if [[ ! "$name" =~ ^(${concatStringsSep "|" rootApplications})$ ]]; then
          echo "${config.user.home}"
        fi
      }

      syncApp() {
        local src="$1"
        local dst="$2"
        ${rsync}/bin/rsync -aLci "$src" "$dst" | ${gnugrep}/bin/grep -c ">f" || true
      }

      applications="${config.system.build.applications}"

      mkdir -p "${config.user.home}/Applications/"
      echo "Looking for mac apps in $applications"

      find "$applications"/Applications/* -maxdepth 1 -type l |
      while read -r app; do
        name=$(basename "$app")
        printf " Found %s" "$name"

        src=$(/usr/bin/stat -f%Y "$app")
        dst=$(home "$name")/Applications

        printf " - Synchronizing..\r"
        changes=$(syncApp "$src" "$dst")
        if [[ "$changes" -ne 0 ]]; then
          printf "%-40s -> Updated %s file(s)\n" "$name" "$changes"
        else
          printf "%-40s -> Up to date\n" "$name"
        fi
      done
    '');
  };
}
