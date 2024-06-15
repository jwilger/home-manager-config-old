{ lib, pkgs, ... }:
{
    home = {
        packages = with pkgs; [
            home-manager
            powerline
            powerline-fonts
            git-crypt
            _1password
            _1password-gui
        ];

        username = "jwilger";
        stateVersion = "23.11";

        sessionVariables = {
            VISUAL = "nvim";
            EDITOR = "nvim";
            NIX_BUILD_SHELL = "zsh";
        };
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

    programs = {
        git = {
            enable = true;
              userName = "John Wilger";
              userEmail = "john@johnwilger.com";

            ignores = [
              # ignore direv files
              ".envrc"
            ];
            difftastic = { enable = true; };

            extraConfig = {
              commit.gpgsign = true;
              merge.conflictstyle = "zdiff3";
              user.signingkey = "8A978D837C6A13DC";

              pull = { ff = "only"; };
              push = { default = "current"; };
            };
        };

        gpg = {
            enable = true;
            mutableKeys = true;
            mutableTrust = true;
        };

        direnv = {
            enable = true;
            enableZshIntegration = true;
        };
        starship = {
            enable = true;
            enableZshIntegration = true;
        };
        tmux = {
            aggressiveResize = true;
            baseIndex = 1;
            enable = true;
            extraConfig = ''
            set -g detach-on-destroy off
            set -g set-clipboard on
            is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE 'vim|neovim'"
            bind-key -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
            bind-key -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
            bind-key -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
            bind-key -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
            setw -g mode-keys vi
            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R
            bind-key -r C-h select-window -t :-
            bind-key -r C-l select-window -t :+
            bind -r H resize-pane -L 5
            bind -r J resize-pane -D 5
            bind -r K resize-pane -U 5
            bind -r L resize-pane -R 5
            set -g other-pane-width 10
            bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection -x
            bind i last-window
            set -g renumber-windows on
            bind-key C-a send-prefix
            unbind-key C-z
            bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded tmux configuration!"
            bind \\ split-window -h
            bind - split-window -v
            setw -g monitor-activity off
            set -g visual-activity on
            set-window-option -g window-active-style bg=terminal,fg=terminal
            set-window-option -g window-style bg=terminal,fg=gray
            '';
            keyMode = "vi";
            mouse = true;
            plugins = 
                with pkgs; [
                    {
                        plugin = tmuxPlugins.catppuccin;
                        extraConfig = ''
                        source ${powerline}/share/tmux/powerline.conf
                        set -g @catppuccin_window_left_separator ""
                        set -g @catppuccin_window_right_separator " "
                        set -g @catppuccin_window_middle_separator " █"
                        set -g @catppuccin_window_number_position "right"
                        set -g @catppuccin_window_default_fill "number"
                        set -g @catppuccin_window_default_text "#W"
                        set -g @catppuccin_window_current_fill "number"
                        set -g @catppuccin_window_current_text "#W"
                        set -g @catppuccin_status_modules_right "user host session"
                        set -g @catppuccin_status_left_separator  " "
                        set -g @catppuccin_status_right_separator ""
                        set -g @catppuccin_status_fill "icon"
                        set -g @catppuccin_status_connect_separator "no"
                        set -g @catppuccin_directory_text "#{pane_current_path}"
                        '';
                    }
                    tmuxPlugins.yank
                    tmuxPlugins.prefix-highlight
                ];
            shortcut = "a";
            tmuxinator.enable = true;
        };
        zsh = {
            enable = true;
            defaultKeymap = "vicmd";
            enableCompletion = true;
            history = {
                ignoreDups = true;
                share = true;
            };
            oh-my-zsh = {
                enable = true;
                plugins = [
                    "git"
                    "sudo"
                    "keychain"
                    "direnv"
                    "mix"
                    "pyenv"
                    "gpg-agent"
                ];
            };
            plugins = [
                {
                    name = "zsh-nix-shell";
                    file = "nix-shell.plugin.zsh";
                    src = pkgs.fetchFromGitHub {
                      owner = "chisui";
                      repo = "zsh-nix-shell";
                      rev = "v0.8.0";
                      sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
                    };
                }
            ];
            shellAliases = {
                # Git
                gst="git status";
                gci="git commit";
                gap="git add --patch";

                # OS
                ls="ls -lGh";
                envs="env | sort";
                envg="env | grep -i";

                # Random
                guid="uuidgen | tr \"[:upper:]\" \"[:lower:]\"";
                publicip="dig +short myip.opendns.com @resolver1.opendns.com";
                localip="ifconfig | grep \"inet \" | grep -v 127.0.0.1 | cut -d\\  -f2";

                # tmuxinator
                tma="tmux attach";
                tm="tmuxinator start";

                # GitHub CLI
                ghr="gh run watch";
            };
            syntaxHighlighting = {
                enable = true;
            };
        };
    };

    xdg.configFile."starship.toml".source = ./starship.toml;
}
