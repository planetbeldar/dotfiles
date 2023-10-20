# WORK IN PROGRESS
{ config, options, lib, pkgs, ... }:

let
  inherit (lib) util mkIf;
  inherit (pkgs) mkYarnPackage fetchFromGitHub runCommand jq nodejs;

  name = "mjml";
  version = "4.13.0";
  src = fetchFromGitHub {
    owner = "mjmlio";
    repo = name;
    rev = "v${version}";
    sha256 = "FfhER0kA8kMTBfC8MRh1J40P8YsdyKmCMPWdeJr2kMc=";
  };
  patchedPackageJSON = runCommand "${name}-package.json" {} ''
    ${jq}/bin/jq '.name = "mjml" | .version = "${version}"' ${src}/package.json > $out
  '';

  mjml = pkgs.buildNpmPackage {
    inherit name version src;

    npmDepsHash = "sha256-nvYGCiE6Xf00+f7pEIQ7v/VK7ctG/3Y5DdrIE2gU7p8=";
    # The prepack script runs the build script, which we'd rather do in the build phase.
    npmPackFlags = [ "--ignore-scripts" ];

    postPatch = ''
      ls ${nodejs}/bin
      ${nodejs}/bin/npm i --package-lock-only
    '';
  };

  # mjml = mkYarnPackage {
  #   inherit version name src;
  #   packageJSON = patchedPackageJSON;

  #   doDist = false;

  #   patchPhase = ''
  #     cp ${patchedPackageJSON} package.json
  #   '';

  #   preInstall = ''
  #     echo hello world
  #     pwd
  #     mkdir -p $out/bin
  #     cp -a ${src}/packages/mjml/bin/mjml $out/bin/
  #   '';
  # };

  cfg = config.modules.dev.mjml;
in {
  options.modules.dev.mjml = {
    enable = util.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = [ mjml ];
    homebrew.brews = [ "mjml" ];
  };
}
