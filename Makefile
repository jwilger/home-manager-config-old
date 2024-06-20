SHELL := /bin/zsh

.PHONY: all update clean check-nix pull flake-update

all: check-nix check-home-manager update import-gpg-key

check-nix:
	@command -v nix >/dev/null 2>&1 || { echo >&2 "Installing Nix..."; curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh;}

check-home-manager:
	@command -v home-manager >/dev/null 2>&1 || { echo >&2 "Installing Home Manager..."; nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager; nix-channel --update; nix-shell '<home-manager>' -A install; echo "source $$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" >> $$HOME/.zprofile; tset; }

update: pull flake-update
	home-manager switch --flake .

pull:
	git pull

flake-update:
	nix flake update

import-gpg-key:
	eval $$(op signin --account my) && \
	KEY_DATA=$$(op document get "Personal GPG Key" | base64 --decode) && \
	KEY_ID=$$(echo "$$KEY_DATA" | gpg --list-packets 2>/dev/null | awk '$$1=="keyid:"{print $$2; exit}') && \
	echo "$$KEY_DATA" | gpg --import --allow-secret-key-import --import-options restore && \
	(echo 5; echo y; echo save) | gpg --command-fd 0 --no-tty --no-greeting -q --edit-key "$$KEY_ID" trust

clean:
	nix-collect-garbage -d

