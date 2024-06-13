{ lib, pkgs, ... }:
{
    home = {
        packages = with pkgs; [
            home-manager
        ];

        username = "jwilger";
        stateVersion = "23.11";

        sessionVariables = {
            VISUAL = "nvim";
            EDITOR = "nvim";
        };
    };

    programs = {
        git = {
            enable = true;
            userName = "John Wilger";
            userEmail = "john@johnwilger.com";
        };
        starship = {
            enable = true;
            enableZshIntegration = true;
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
            plugins = [ "git" "sudo" "keychain" "direnv" "mix" "pyenv" ];
            };
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
}
