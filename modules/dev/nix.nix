{ inputs, config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf mkMerge;
  inherit (pkgs) nixfmt cachix hydra-check jq nodePackages direnv nix-direnv;
  inherit (pkgs.stdenv) isDarwin;

  cfg = config.modules.dev.nix;
in {
  options.modules.dev.nix = {
    enable = util.mkBoolOpt true;
  };

  config = mkIf cfg.enable (mkMerge [
    # (mkIf (isDarwin == false) {
    #   programs.direnv = {
    #     enable = true;
    #     nix-direnv.enable = true;
    #     nix-direnv.enableFlakes = true;
    #   };
    # })
    {
      nixpkgs.overlays = [ inputs.nix-direnv.overlay ];

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

      environment.systemPackages = [
        nixfmt
        cachix
        nodePackages.eslint
        jq
        direnv
        nix-direnv
        # hydra-check
      ];
    }
  ]);
}
