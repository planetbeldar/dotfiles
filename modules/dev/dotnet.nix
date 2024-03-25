{ config, options, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (pkgs) stdenv omnisharp-roslyn dotnet-sdk csharpier;

  cfg = config.modules.dev.dotnet;
in {
  options.modules.dev.dotnet = {
    enable = mkEnableOption "enable dotnet-sdk and omnisharp";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      dotnet-sdk
      omnisharp-roslyn
      csharpier
    ];

    env = {
      DOTNET_ROOT               = "${dotnet-sdk.out}";
      DOTNET_CLI_HOME           = "$XDG_DATA_HOME"; # dotnet cli appends the path with .dotnet :(
      NUGET_PACKAGES            = "$XDG_DATA_HOME/NuGet/packages";
      NUGET_HTTP_CACHE_PATH     = "$XDG_DATA_HOME/NuGet/v3-cache";
      NUGET_PLUGINS_CACHE_PATH  = "$XDG_DATA_HOME/NuGet/plugins-cache";

      PATH = [ "$DOTNET_CLI_HOME/.dotnet/tools" ];
    };
  };
}
