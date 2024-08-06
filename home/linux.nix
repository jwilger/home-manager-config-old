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
      extraConfig = ''
        allow-preset-passphrase
      '';
    };
  };

  xdg.configFile."regolith3/Xresources".source = ../Xresources;
}
