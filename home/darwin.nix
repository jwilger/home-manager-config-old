{ lib, pkgs, ... }:
{
    home = {
        homeDirectory = "/Users/jwilger";
        stateVersion = "23.11";
    };

    programs = {
        git = {
            extraConfig = {
                gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
            };
        };

        ssh = {
            extraConfig = ''
            Host *
                IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
            '';
        };

        vscode = {
            enable = true;
        };
    };
}
