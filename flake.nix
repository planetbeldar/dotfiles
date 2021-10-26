{
  description = "In the heart of the (dotfiles) city";

  inputs = {
    # Core
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-direnv
    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Darwin
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Emacs
    emacs = {
      url = "path:./overlays/emacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, darwin, ... }:
    let
      inherit (lib.util) mapModules mapModules' mapModulesRec mapDarwinHosts mapNixosHosts traceImportMsg traceCallPackageMsg;
      traceCallPackage = traceCallPackageMsg "flake.nix:";
      traceImport = traceImportMsg "flake.nix:";
      system = "x86_64-darwin";

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        config.input-fonts.acceptLicense = true;
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };

      overlay = final: prev: {
        # unstable = pkgs';
        local = self.packages."${system}";
      };

      pkgs  = mkPkgs nixpkgs [ overlay ];
      # pkgs' = mkPkgs nixpkgs-unstable [];

      lib = nixpkgs.lib.extend
        (self: super: { util = import ./lib { inherit pkgs inputs darwin; lib = self; };});

      dotfiles = traceImport ./.;

      darwinHosts = mapDarwinHosts ./hosts/darwin {};
      nixosHosts = mapNixosHosts ./hosts/nixos {};
    in
    {
      inherit overlay;
      overlays = mapModules ./overlays (p: import p { inherit lib; });

      packages."${system}" = mapModules ./packages traceCallPackage;

      darwinModules =
        { inherit dotfiles; } // mapModulesRec ./modules traceImport;
      darwinConfigurations = darwinHosts;

      # nixosModules =
      #   { inherit dotfiles; } // mapModulesRec ./modules import;
    };
}
