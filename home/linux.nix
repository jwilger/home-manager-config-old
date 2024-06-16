{ lib, pkgs, ... }:
{
    home = {
        homeDirectory = "/home/jwilger";
        stateVersion = "23.11";

        file.".ssh/allowed_signers" = {
            enable = true;
            text = ''
            john@johnwilger.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDonsmPpmdFGbXwVP1mIj+4VOgrifXlgYF8+N1pTRz17
            johnwilger@artium.ai ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDonsmPpmdFGbXwVP1mIj+4VOgrifXlgYF8+N1pTRz17
            '';
        };
    };

    services = {
        gpg-agent = {
            enable = true;
            defaultCacheTtl = 3600;
            maxCacheTtl = 36000;
            extraConfig = ''
            allow-preset-passphrase
            '';
        };
    };

    programs = {
        git = {
            extraConfig = {
                gpg = {
                    ssh = {
                        allowedSignersFile = "~/.ssh/allowed_signers";
                    };
                };
            };
        };
    };
}
