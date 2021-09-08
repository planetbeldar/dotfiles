{ lib
, stdenv
, pkgs
, fetchurl
}:
let
  inherit (pkgs) pkg-config autoconf automake ncurses libxml2
    gnutls texinfo gettext jansson;

  inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Carbon
    Cocoa IOKit OSAKit Quartz QuartzCore WebKit
    ImageCaptureCore GSS ImageIO;

  inherit (lib) platforms licenses;

  pname = "emacs";
  version = "27.2";

  emacsName = "${pname}-${version}";
  macportVersion = "8.2";

  patches = [
    ./patches/emacs-26.2-rc1-mac-7.5-no-title-bar.patch
    ./patches/multi-tty-27.diff
    ./patches/mac-arm-fix.diff
  ];
in
stdenv.mkDerivation {
  inherit pname version patches;

  name = "${emacsName}-macport-${macportVersion}";

  src = fetchurl {
    url = "https://bitbucket.org/mituharu/emacs-mac/get/${emacsName}-mac-${macportVersion}.tar.gz";
    sha256 = "80c7377c95591cd8034443a05d596a6e0440adfc6a2633ad143167fadac3d828";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ ncurses pkg-config autoconf automake ];

  buildInputs = [ libxml2 gnutls texinfo gettext jansson
    AppKit Carbon Cocoa IOKit OSAKit Quartz QuartzCore WebKit
    ImageCaptureCore GSS ImageIO   # may be optional
  ];

  # postPatch = ''
  #   substituteInPlace lisp/international/mule-cmds.el \
  #     --replace /usr/share/locale ${gettext}/share/locale

  #   # use newer emacs icon
  #   cp nextstep/Cocoa/Emacs.base/Contents/Resources/Emacs.icns mac/Emacs.app/Contents/Resources/Emacs.icns
# 
#     # Fix sandbox impurities.
#     substituteInPlace Makefile.in --replace '/bin/pwd' 'pwd'
#     substituteInPlace lib-src/Makefile.in --replace '/bin/pwd' 'pwd'
# 
#     # Reduce closure size by cleaning the environment of the emacs dumper
#     substituteInPlace src/Makefile.in \
#       --replace 'RUN_TEMACS = ./temacs' 'RUN_TEMACS = env -i ./temacs'
 #  '';

  preConfigure = "./autogen.sh";

  configureFlags = [
    #"LDFLAGS=-L${ncurses.out}/lib"
    "--with-xml2"
    "--with-gnutls"
    "--with-mac"
    "--with-modules"
    "--enable-mac-app=$$out/Applications"
  ];

  CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=110200 -g -O2";
  #CFLAGS = "-O3";
  #LDFLAGS = "-O3 -L${ncurses.out}/lib";

  meta = {
    description = "The extensible, customizable text editor - macport version";
    homepage    = "https://bitbucket.org/mituharu/emacs-mac";
    license     = licenses.gpl3Plus;
    # maintainers = [];
    platforms   = platforms.darwin;

    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more.  At its
      core is an interpreter for Emacs Lisp, a dialect of the Lisp
      programming language with extensions to support text editing.
      The features of GNU Emacs include: content-sensitive editing modes,
      including syntax coloring, for a wide variety of file types including
      plain text, source code, and HTML; complete built-in documentation,
      including a tutorial for new users; full Unicode support for nearly all
      human languages and their scripts; highly customizable, using Emacs
      Lisp code or a graphical interface; a large number of extensions that
      add other functionality, including a project planner, mail and news
      reader, debugger interface, calendar, and more.  Many of these
      extensions are distributed with GNU Emacs; others are available
      separately.
      This is the "Mac port" addition to GNU Emacs 26. This provides a native
      GUI support for Mac OS X 10.6 - 10.12. Note that Emacs 23 and later
      already contain the official GUI support via the NS (Cocoa) port for
      Mac OS X 10.4 and later. So if it is good enough for you, then you
      don't need to try this.
    '';
  };
}
