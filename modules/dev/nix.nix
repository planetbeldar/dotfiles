{ inputs, config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) nixfmt cachix hydra-check direnv nix-direnv undmg xmlstarlet gdb jq yq;
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.modules.dev.nix;
in {
  options.modules.dev.nix = {
    enable = util.mkBoolOpt true;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nixpkgs.overlays = [ inputs.nix-direnv.overlays.default ];

      nix.extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';

      home.configFile = {
        "direnv/direnvrc".text = ''
          source ${nix-direnv}/share/nix-direnv/direnvrc

          ## Put all direnv folders in one place (XDG_CACHE_HOME)
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | shasum | cut -d ' ' -f 1
            )}"
          }
        '';
      };

      modules.shell.zsh.rcInit = ''
        eval "$(direnv hook zsh)"
      '';

      modules.shell.zsh.aliases = {
        nfu  = ''nix flake update'';
        nfU  = ''find . -name \"flake.nix\" -exec sh -c \"pushd \$(dirname {}) && nix flake update && popd\" \;'';
        nfui = ''nix flake lock --update-input'';
        nfs  = ''nix flake show'';
      };

      environment.systemPackages = [
        nixfmt
        cachix
        jq
        yq
        direnv
        nix-direnv
        undmg
        xmlstarlet
        # gdb
        # hydra-check
      ];
    }
  ]);
}
