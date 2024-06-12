{ lib, pkgs, ... }:
{
    home = {
        packages = with pkgs; [
            home-manager
        ];

        username = "jwilger";
        homeDirectory = "/Users/jwilger";
        stateVersion = "23.11";
    };
}