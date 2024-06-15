{ lib, pkgs, ... }:
{
    home = {
        homeDirectory = "/home/jwilger";
        stateVersion = "23.11";
    };

    services = {
        gpg-agent = {
            enable = true;
            defaultCacheTtl = 3600;
            maxCacheTtl = 36000;
            defaultCacheTtlSsh = 3600;
            maxCacheTtlSsh = 36000;
            enableSshSupport = true;
            extraConfig = ''
            allow-preset-passphrase
            '';
        };
    };
}
