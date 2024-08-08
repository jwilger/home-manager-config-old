{ lib, pkgs, ... }:
{
  home = {
    homeDirectory = "/home/jwilger";
    stateVersion = "23.11";
    packages = with pkgs; [
      realvnc-vnc-viewer
    ];
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
    dunst = {
      enable = true;
    };
  };

  programs = {
    i3status-rust = {
      enable = true;
      bars = {
        default = {
          settings = {
            theme =
              {
                theme = "ctp-macchiato";
                overrides = {
                  separator = " ";
                  end_separator = " ";
                };
              };
          };
          icons = "awesome6";
          blocks = [
            { block = "net"; }
            {
              block = "disk_space";
              path = "/";
              info_type = "used";
              format = "$icon $percentage";
              alert = 50;
              warning = 40;
            }
            {
              block = "memory";
              format = "$icon $mem_used_percents";
              format_alt = "$icon $swap_used_percents";
            }
            {
              block = "notify";
              driver = "dunst";
            }
            {
              block = "sound";
              driver = "pulseaudio";
            }
            {
              block = "time";
              format = "$icon $timestamp.datetime(f:'%D %R') ";
            }
          ];
        };
      };
    };
  };

  xdg.configFile."regolith3/Xresources".source = ../Xresources;
}
