{ lib }:
let
  version = "3.3.10";
in
(final: prev: {
  yabai = prev.yabai.overrideAttrs (drv: {
    inherit version;

    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "1z95njalhvyfs2xx6d91p9b013pc4ad846drhw0k5gipvl03pp92";
    };
  });
})

# self: super: {
#   yabai = super.yabai.overrideAttrs (
#     o: rec {
#       version = "3.3.8";
#       src = builtins.fetchTarball {
#         url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
#         sha256 = "1qh1vf52j0b3lyrm005c8c98s39rk1lq61rrq0ml2yr4h77rq3xv";
#       };

#       installPhase = ''
#         mkdir -p $out/bin
#         mkdir -p $out/share/man/man1/
#         cp ./bin/yabai $out/bin/yabai
#         cp ./doc/yabai.1 $out/share/man/man1/yabai.1
#       '';
#     }
#   );
# }
