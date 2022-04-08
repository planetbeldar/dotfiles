{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) stdenv omnisharp-roslyn dotnetCorePackages;

  cfg = config.modules.dev.dotnet;
  dotnet-sdk = dotnetCorePackages.sdk_6_0;
in {
  options.modules.dev.dotnet = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      dotnet-sdk
      omnisharp-roslyn
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
