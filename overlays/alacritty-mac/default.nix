{ lib }:
let
  patches = drv: (drv.patches or []) ++ [
    ./patches/alacritty-crossfont_source.patch
  ];
in
(final: prev: {
  alacritty-mac = prev.alacritty.overrideAttrs (drv: {
    patches = patches drv;

    # the patch will alter the cargoSha256 hash:
    # cargoSha256 = "0anbj9i9yylb4b9vpx9f36x94bpdr35ri9s5vc2isj0icpal9qr3";
    cargoDeps = drv.cargoDeps.overrideAttrs (lib.const {
      patches = patches drv;
      outputHash = "09ndwrab9llrlgqg0ji9xibpbmvsa0cqajkwx32zfdcwhrnisgmv";
      # outputHash = lib.fakeHash;
    });
  });
})
