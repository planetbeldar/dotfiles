{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) stdenv rustup rust-analyzer cargo-edit;

  cfg = config.modules.dev.rust;
in {
  options.modules.dev.rust = {
    enable = mkEnableOption "enable rust";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      rustup
      rust-analyzer # lsp
      cargo-edit
      # rustfmt # formatting
    ];

    env = {
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      PATH = [ "$CARGO_HOME/bin" ];
    };
  };
}
