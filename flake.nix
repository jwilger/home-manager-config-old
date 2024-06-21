{
    description = "My Home Manager configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        _1password-shell-plugins.url = "github:1Password/shell-plugins";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ nixpkgs,  home-manager, ... }:
        let
            mkHomeConfig = machineModule: system: home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
                modules = [
                    ./home/common.nix
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
