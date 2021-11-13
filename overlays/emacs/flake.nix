{
  description = "Emacs 28 for macOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    emacs-src = {
      # no evaluation allowd here, cannot set branch dynamically (would like to use generated settings.nix)
      url = "github:emacs-mirror/emacs/emacs-28";
      flake = false;
    };

    emacs-vterm-src = {
      url = "github:akermu/emacs-libvterm";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, emacs-src, emacs-vterm-src }:
    let
      pkgs = import nixpkgs {
        config = { };
        system = "x86_64-darwin";
      };

      inherit (pkgs)
        lib stdenv cmake libtool glib libvterm-neovim ncurses emacs darwin;
      inherit (import ./settings.nix) emacsBranch emacsVersion;
    in {
      packages.x86_64-darwin = pkgs.extend self.overlay;

      overlay = final: prev: {
        emacs-vterm = stdenv.mkDerivation {
          pname = "emacs-vterm";
          version = "master";

          src = emacs-vterm-src;

          nativeBuildInputs = [ cmake libtool glib.dev ];

          buildInputs = [ glib.out libvterm-neovim ncurses ];

          cmakeFlags = [ "-DUSE_SYSTEM_LIBVTERM=yes" ];

          preConfigure = ''
            echo "include_directories(\"${glib.out}/lib/glib-2.0/include\")" >> CMakeLists.txt
            echo "include_directories(\"${glib.dev}/include/glib-2.0\")" >> CMakeLists.txt
            echo "include_directories(\"${ncurses.dev}/include\")" >> CMakeLists.txt
            echo "include_directories(\"${libvterm-neovim}/include\")" >> CMakeLists.txt
          '';

          installPhase = ''
            mkdir -p $out
            cp ../vterm-module.so $out
            cp ../vterm.el $out
          '';
        };

        emacs = (emacs.override {
          srcRepo = true;
          nativeComp = true;
          withXwidgets = true;
        }).overrideAttrs (drv: {
          version = emacsVersion;
          src = emacs-src;

          buildInputs = drv.buildInputs ++ [ darwin.apple_sdk.frameworks.WebKit ];

          patches =
            [ ./patches/fix-window-role.patch ./patches/no-titlebar.patch ];

          postPatch = drv.postPatch + ''
            substituteInPlace lisp/loadup.el \
            --replace '(emacs-repository-get-branch)' '"${emacsBranch}"'
          '';

          postInstall = drv.postInstall + ''
            cp ${self.packages.x86_64-darwin.emacs-vterm}/vterm.el $out/share/emacs/site-lisp/vterm.el
            cp ${self.packages.x86_64-darwin.emacs-vterm}/vterm-module.so $out/share/emacs/site-lisp/vterm-module.so
          '';

          CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=110203 -g -O3";
        });
      };
    };
}
