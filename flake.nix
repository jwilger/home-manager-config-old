{
  description = "Home Manager configuration of jwilger";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ssh-agent-switcher = {
      url = "./ssh-agent-switcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ssh-agent-switcher, catppuccin, ... }:
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
            catppuccin.homeManagerModules.catppuccin
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
