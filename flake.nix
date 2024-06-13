{
    description = "My Home Manager configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixvim-config = {
            url = "github:jwilger/nixvim-config";
        };
    };

    outputs = { nixvim-config, nixpkgs, home-manager, ... }: {
        homeConfigurations = {
            "jwilger@gregor" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "x86_64-linux"; };
                modules = [
                  ./home/common.nix
                  ./home/linux.nix
                  {
                    home.packages = [ nixvim-config.packages."x86_64-linux".default ];
                  }
                  ./home/gregor.nix
                ];
            };
            "jwilger@Sandor" = home-manager.lib.homeManagerConfiguration {
                pkgs = import nixpkgs { system = "aarch64-darwin"; };
                modules = [
                  ./home/common.nix
                  ./home/darwin.nix
                  {
                    home.packages = [ nixvim-config.packages."aarch64-darwin".default ];
                  }
                  ./home/gregor.nix
                ];
            };
        };
    };
}
