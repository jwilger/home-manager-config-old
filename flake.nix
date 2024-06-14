{
    description = "My Home Manager configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";
        flake-utils.url = "github:numtide/flake-utils";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvim-config = {
            url = "github:jwilger/nixvim-config";
        };
    };

    outputs = { nixvim-config, nixpkgs, flake-utils, home-manager, ... } @ inputs:
        let
            mkHomeConfig = machineModule: system: home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { inherit system; };
                modules = [
                    ./home/common.nix
                    {
                        home.packages = [ nixvim-config.packages."${system}".default ];
                    }
                    machineModule
                ];

                extraSpecialArgs = {
                    inherit inputs system;
                };
            };
        in {
            homeConfigurations = {
                "jwilger@gregor" = mkHomeConfig ./home/linux.nix "x86_64-linux";
                "jwilger@Sandor" = mkHomeConfig ./home/darwin.nix "aarch64-darwin";
                "jwilger@sierra" = mkHomeConfig ./home/darwin.nix "aarch64-darwin";
            };
        };
}
