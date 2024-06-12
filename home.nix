{ lib, pkgs, ... }:
{
    home = {
        packages = with pkgs; [
            home-manager
        ];

        username = "jwilger";
        homeDirectory = if pkgs.stdenv.isLinux then "/home/jwilger" else "/Users/jwilger";
        stateVersion = "23.11";
    };
}