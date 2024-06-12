{ lib, pkgs, ... }:
{
    home = {
        packages = with pkgs; [
            hello
        ];

        username = "jwilger";
        homeDirectory = "/Users/jwilger";
        stateVersion = "23.11";
    };
}