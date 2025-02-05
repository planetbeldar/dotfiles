{ ... }:
final: prev: {
  clisp = prev.clisp.overrideAttrs (_: rec {
    version = "2.49.95-unstable-2024-12-28";
    src = final.pkgs.fetchFromGitLab {
      owner = "gnu-clisp";
      repo = "clisp";
      rev = "c3ec11bab87cfdbeba01523ed88ac2a16b22304d";
      hash = "sha256-xXGx2FlS0l9huVMHqNbcAViLjxK8szOFPT0J8MpGp9w=";
    };
    patches = [];
    preConfigure = "";
  });
}
