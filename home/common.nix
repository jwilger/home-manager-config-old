{ pkgs, config, ... }:
{
  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;
  news.display = "silent";
  catppuccin =
    {

      enable = true;
      accent = "pink";
      flavor = "macchiato";
      pointerCursor = {
        enable = true;
      };
    };

  home = {
    packages = with pkgs;
      [
        neovim
        tree-sitter
        gdu
        bottom
        python312
        python312Packages.pynvim
        nodePackages.nodejs
        nodePackages.neovim
        powerline
        powerline-fonts
        git-crypt
        _1password
        _1password-gui
        gcc
        gnumake
        go
        cargo
        nerdfonts
        noto-fonts-color-emoji
        slack
        ripgrep
      ];

    username = "jwilger";
    stateVersion = "23.11";

    sessionVariables = {
      NIX_BUILD_SHELL = "zsh";
      EDITOR = "nvim";
      SSH_AUTH_SOCK = "/home/jwilger/.1password/agent.sock";
    };

    file.".zlogin".text = ''
              echo "Welcome, ''${USER}!"
              if [ ! -e "/tmp/ssh-agent.''${USER}" ]; then
          	    if [ -n "''${ZSH_VERSION}" ]; then
              	    eval ~/.nix-profile/bin/ssh-agent-switcher 2>/dev/null "&!"
          	    else
              	    ~/.nix-profile/bin/ssh-agent-switcher 2>/dev/null &
              	    disown 2>/dev/null || true
          	    fi
      	    fi
      	    export SSH_AUTH_SOCK="/tmp/ssh-agent.''${USER}" 
    '';

  };

  programs = {
    lazygit = {
      enable = true;
      settings = {
        gui = {
          expandFocusedSidePanel = true;
          showRandomTip = false;
          nerdFontsVersion = "3";
        };
      };
    };
    git = {
      enable = true;
      userName = "John Wilger";
      userEmail = "john@johnwilger.com";

      ignores = [
        # ignore direv files
        ".envrc"
        ".direnv/"
      ];
      difftastic = {
        enable = true;
      };

      extraConfig = {
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/${
config.xdg.configFile."ssh/allowed_signers".target
}";
        commit.gpgsign = true;
        merge.conflictstyle = "zdiff3";
        merge.tool = "nvimdiff";
        diff.tool = "nvimdiff";
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwXlUIgMZDNewfvIyX5Gd1B1dIuLT7lH6N+2+FrSaSU";
        gpg.ssh.program = "op-ssh-sign";
        log.showSignature = true;

        pull = {
          ff = "only";
        };
        push = {
          default = "current";
        };
      };
    };

    gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      publicKeys = [
        {
          source = builtins.fetchurl {
            url = "https://github.com/web-flow.gpg";
            sha256 = "117gldk49gc76y7wqq6a4kjgkrlmdsrb33qw2l1z9wqcys3zd2kf";
          };
          trust = 4;
        }
      ];
    };

    home-manager = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    ssh = {
      enable = true;
      compression = true;
      forwardAgent = true;
      controlMaster = "yes";
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "[╭╴](fg:#505050)$os$username$hostname$sudo$directory$git_branch$git_commit$git_state$git_metrics$git_status$jobs$memory_usage[ ](fg:#242424)$cmd_duration$fill$line_break[╰╴](fg:#505050)[$status $localip $character]($style)";
        add_newline = true;
        os = {
          format = "[$symbol ]($style)[ ]()";
          style = "fg:#AAAAAA";
          disabled = false;
          symbols = {
            Alpine = "";
            Amazon = "";
            Android = "";
            Arch = "";
            CentOS = "";
            Debian = "";
            DragonFly = "🐉";
            Emscripten = "🔗";
            EndeavourOS = "";
            Fedora = "";
            FreeBSD = "";
            Garuda = "";
            Gentoo = "";
            HardenedBSD = "聯";
            Illumos = "🐦";
            Linux = "";
            Macos = "";
            Manjaro = "";
            Mariner = "";
            MidnightBSD = "🌘";
            Mint = "";
            NetBSD = "";
            NixOS = "";
            OpenBSD = "";
            OpenCloudOS = "☁️";
            openEuler = "";
            openSUSE = "";
            OracleLinux = "⊂⊃";
            Pop = "";
            Raspbian = "";
            Redhat = "";
            RedHatEnterprise = "";
            Redox = "🧪";
            Solus = "";
            SUSE = "";
            Ubuntu = "";
            Unknown = "";
            Windows = "";
          };
        };
        username = {
          format = "[ ](fg:green bold)[$user]($style)[ ]()";
          style_user = "fg:green bold";
          style_root = "fg:red bold";
          show_always = false;
          disabled = false;
        };
        hostname = {
          format = "[$ssh_symbol ](fg:green bold)[$hostname](fg:green bold)[ ]()";
          ssh_only = true;
          ssh_symbol = "";
          disabled = false;
        };
        directory = {
          format = "[ ](fg:cyan bold)[$read_only]($read_only_style)[$repo_root]($repo_root_style)[$path]($style)";
          style = "fg:cyan bold";
          home_symbol = " ~";
          read_only = " ";
          read_only_style = "fg:cyan";
          truncation_length = 3;
          truncation_symbol = "…/";
          truncate_to_repo = true;
          repo_root_format = "[ ](fg:cyan bold)[$read_only]($read_only_style)[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[ ]()";
          repo_root_style = "fg:cyan bold";
          use_os_path_sep = true;
          disabled = false;
        };
        git_branch = {
          format = "[❯ $symbol $branch(:$remote_branch)]($style)[ ]()";
          style = "fg:#E04D27";
        };
        git_commit = {
          format = "[\($hash$tag\)]($style)[ ]()";
          style = "fg:#E04D27";
          commit_hash_length = 8;
          tag_symbol = " ";
          disabled = false;
        };
        git_metrics = {
          format = "[[+\${added}/](\${added_style})[-\${deleted}](\${deleted_style})[  ]()]()";
          added_style = "fg:#E04D27";
          deleted_style = "fg:#E04D27";
          disabled = false;
        };
        git_status = {
          format = "([$all_status$ahead_behind]($style))";
          style = "fg:#E04D27";
          conflicted = "[  \${count} ](fg:red)";
          ahead = "[ ⇡ \${count} ](fg:yellow)";
          behind = "[ ⇣ \${count} ](fg:yellow)";
          diverged = "[ ⇕ \${ahead_count}⇡ \${behind_count}⇣ ](fg:yellow)";
          up_to_date = "[ ✓ ](fg:green)";
          untracked = "[ ﳇ \${count} ](fg:red)";
          stashed = "[  \${count} ](fg:#A52A2A)";
          modified = "[  \${count} ](fg:#C8AC00)";
          staged = "[  \${count} ](fg:green)";
          renamed = "[ ᴂ \${count} ](fg:yellow)";
          deleted = "[ 🗑 \${count} ](fg:orange)";
          disabled = false;
        };
        jobs = {
          format = "[  ](fg:blue bold)[$number$symbol]($style)";
          style = "fg:blue";
          symbol = "省";
          symbol_threshold = 1;
          number_threshold = 4;
          disabled = false;
        };
        memory_usage = {
          format = "[  ](fg:purple bold)[$symbol \${ram} \${swap}]($style)";
          style = "fg:purple";
          symbol = "﬙ 北";
          threshold = 75;
          disabled = false;
        };
        cmd_duration = {
          format = "[  $duration ]($style)";
          style = "fg:yellow";
          min_time = 500;
          disabled = false;
        };
        fill = {
          style = "fg:#505050";
          symbol = "─";
        };
        status = {
          format = "[$symbol$status $hex_status  $signal_number-$signal_name ]($style)";
          style = "fg:red";
          symbol = "✘ ";
          disabled = false;
        };
        localip = {
          format = "[$localipv4 ](fg:green bold)";
          ssh_only = true;
          disabled = true;
        };
      };
    };
    tmux = {
      aggressiveResize = true;
      baseIndex = 1;
      enable = true;
      extraConfig = ''
        set -g default-terminal tmux-256color
        set -g detach-on-destroy off
        set -g set-clipboard on
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE 'vim|neovim|nvim'"
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
      plugins = with pkgs; [
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
          # "gpg-agent"
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
        gst = "git status";
        gci = "git commit";
        gap = "git add --patch";

        # OS
        ls = "ls -lGh";
        envs = "env | sort";
        envg = "env | grep -i";

        # Random
        guid = ''uuidgen | tr "[:upper:]" "[:lower:]"'';
        publicip = "dig +short myip.opendns.com @resolver1.opendns.com";
        localip = ''ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2'';

        # tmuxinator
        tma = "tmux attach";
        tm = "tmuxinator start";

        # Neovim
        vi = "nvim";
        vim = "nvim";
        vimdiff = "nvim -d";

        # GitHub CLI
        ghr = "gh run watch";
      };
      syntaxHighlighting = {
        enable = true;
      };
    };
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 10.0;
      };
    };
  };

  xdg.configFile."ssh/allowed_signers".text = ''
    john@johnwilger.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwXlUIgMZDNewfvIyX5Gd1B1dIuLT7lH6N+2+FrSaSU
    johnwilger@artium.ai ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGwXlUIgMZDNewfvIyX5Gd1B1dIuLT7lH6N+2+FrSaSU
  '';

  xdg.configFile."fontconfig/conf.d/10-nix-fonts.conf".text = ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
    <fontconfig>
      <dir>~/.nix-profile/share/fonts/</dir>
    </fontconfig>
  '';
}
