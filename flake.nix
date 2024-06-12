{
    description = "My Home Manager configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... }:
        let
            lib = nixpkgs.lib;
            system = "aarch64-darwin";
            pkgs = import nixpkgs { inherit system; };
        in {
            homeConfigurations = {
                jwilger = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [ ./home.nix ];
                };
            };
        };
}