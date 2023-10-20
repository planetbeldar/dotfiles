{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) stdenv rustc cargo rust-analyzer cargo-edit rustfmt;

  cfg = config.modules.dev.rust;
in {
  options.modules.dev.rust = {
    enable = mkEnableOption "enable rust";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      # rustup
      cargo-edit
      rust-analyzer # included with rustup
      rustfmt # included with rustup
      rustc # included with rustup
      cargo # included with rustup
    ];

    env = {
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
      PATH = [ "$CARGO_HOME/bin" ];
    };
  };
}
