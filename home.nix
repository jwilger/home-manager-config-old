{ lib, pkgs, ... }:
{
    home = {
        packages = with pkgs; [
        ];

        username = "jwilger";
        homeDirectory = "/Users/jwilger";
        stateVersion = "23.11";
    };
}