{ lib, pkgs, ... }:
{
    home = {
        packages = with pkgs; [
            home-manager
        ];

        username = "jwilger";
        stateVersion = "23.11";
    };

    programs = {
        git = {
            enable = true;
            userName = "John Wilger";
            userEmail = "john@johnwilger.com";
        };
    };
}
