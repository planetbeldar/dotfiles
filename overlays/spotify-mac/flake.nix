{
  description = "Spotify for macOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      pkgs = import nixpkgs { system = "x86_64-darwin"; };
      pname = "spotify-mac";
    in flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.${pname} = import ./overlay.nix { inherit pkgs pname; };
        defaultPackage = self.packages.${system}.${pname};
      }) // {
        overlay = final: prev: {
          spotify-mac = import ./overlay.nix { inherit pkgs pname; };
        };
      };
}
