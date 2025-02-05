{
  description = "In the heart of the (dotfiles) city";

  inputs = {
    # core
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    # home-manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-direnv
    nix-direnv.url = "github:nix-community/nix-direnv";
    nix-direnv.inputs.nixpkgs.follows = "nixpkgs";
    # nix-darwin
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    # Agenix
    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs";
    # mac-overlay
    mac-overlay.url = "github:planetbeldar/mac-overlay";
    mac-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, ... }:
    let
      inherit (lib.util) mapModules mapModules' mapModulesRec mapDarwinHosts mapNixosHosts traceImportMsg traceCallPackageMsg;
      traceCallPackage = traceCallPackageMsg "flake.nix:";
      traceImport = traceImportMsg "flake.nix:";

      mkPkgs = system: pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;
        config.input-fonts.acceptLicense = true;
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-darwin" ];

      overlay = final: prev: {
        # unstable = pkgs';
        local = self.packages."${prev.system}";
      };

      pkgs  = mkPkgs "aarch64-darwin" nixpkgs [ overlay ];
      # pkgs' = mkPkgs nixpkgs-unstable [];

      lib = nixpkgs.lib.extend
        (self: super: { util = import ./lib { inherit pkgs inputs darwin home-manager; lib = self; };});

      dotfiles = traceImport ./.;

      darwinHosts = mapDarwinHosts ./hosts/darwin {};
      nixosHosts = mapNixosHosts ./hosts/nixos {};
    in
    {
      inherit overlay;
      overlays = mapModules ./overlays (p: import p { inherit lib; });

      packages = forAllSystems (system:
        let pkgs = mkPkgs system nixpkgs [overlay ];
        in mapModules ./packages (p: pkgs.callPackage p {})
      );

      darwinModules = { inherit dotfiles; } // mapModulesRec ./modules traceImport;
      darwinConfigurations = darwinHosts;

      # nixosModules =
      #   { inherit dotfiles; } // mapModulesRec ./modules import;
    };
}
