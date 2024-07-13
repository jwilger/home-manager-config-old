{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    _1password-shell-plugins.url = "github:1Password/shell-plugins";

    ssh-agent-switcher = {
      url = "./ssh-agent-switcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ssh-agent-switcher,
      ...
    }:
    let
      mkHomeConfig =
        machineModule: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
          modules = [
            ./home/common.nix
            machineModule
            { home.packages = [ ssh-agent-switcher.packages.${system}.ssh-agent-switcher ]; }
          ];

          extraSpecialArgs = {
            inherit inputs system;
          };
        };
    in
    {
      homeConfigurations = {
        "jwilger@gregor" = mkHomeConfig ./home/linux.nix "x86_64-linux";
        "jwilger@Sandor" = mkHomeConfig ./home/darwin.nix "aarch64-darwin";
        "jwilger@sierra" = mkHomeConfig ./home/darwin.nix "aarch64-darwin";
      };
    };
}
