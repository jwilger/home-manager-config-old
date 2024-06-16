{ lib, pkgs, ... }:
{
    home = {
        homeDirectory = "/Users/jwilger";
        stateVersion = "23.11";
    };

    programs = {
        ssh = {
            extraConfig = ''
            Host *
                IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
            '';
        };
    };
}
