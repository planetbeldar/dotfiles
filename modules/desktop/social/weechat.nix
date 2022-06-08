{ options, config, lib, pkgs, ... }:
let
  inherit (lib) util mkIf;
  inherit (pkgs) stdenv fetchurl;
  inherit (pkgs.weechatScripts)
    multiline weechat-matrix wee-slack colorize_nicks;

  vimode = stdenv.mkDerivation {
    pname = "vimode";
    version = "0.8";

    src = fetchurl {
      url = "https://raw.githubusercontent.com/GermainZ/weechat-vimode/897a33b9fb28c98c4e0a1c292d13536dd57f85c7/vimode.py";
      sha256 = "CeBZLU7QF9EZYWmCa47up0m7UljehhHDrcMsulx0hgg=";
    };

    dontUnpack = true;
    prePatch = ''
      cp $src vimode.py
    '';

    passthru.scripts = [ "vimode.py" ];

    installPhase = ''
      runHook preInstall

      install -D vimode.py $out/share/vimode.py

      runHook postInstall
    '';

    meta = {
      homepage = "https://github.com/GermainZ/weechat-vimode";
      description = "vi/vim-like modes and keybindings";
      license = lib.licenses.gpl3Plus;
    };
  };

  cfg = config.modules.desktop.social.weechat;
  weechat = pkgs.weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = [
        vimode
        multiline
        weechat-matrix
        wee-slack
        colorize_nicks
      ];
      init = ''
        /set weechat.bar.input.items "mode_indicator+[input_prompt]+(away),[input_search], [input_paste],input_text,[vi_buffer]"
        /set weechat.bar.status.items "[time],[buffer_last_number],[buffer_plugin],buffer_number+:+buffer_name+(buffer_modes)+{buffer_nicklist_count}+buffer_zoom+buffer_filter,scroll,[lag],[hotlist],completion,cmd_completion"
        /set plugins.var.python.vimode.search_vim on
        /vimode bind_keys
      '';
    };
  };
in {
  options.modules.desktop.social.weechat = { enable = util.mkBoolOpt false; };

  config = mkIf cfg.enable { environment.systemPackages = [ weechat ]; };
}
