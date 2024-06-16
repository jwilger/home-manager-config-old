SHELL := /bin/zsh

.PHONY: all update clean check-nix

all: check-nix check-home-manager update import-gpg-key

check-nix:
	@command -v nix >/dev/null 2>&1 || { echo >&2 "Installing Nix..."; curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh;}

check-home-manager:
	@command -v home-manager >/dev/null 2>&1 || { echo >&2 "Installing Home Manager..."; nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager; nix-channel --update; nix-shell '<home-manager>' -A install; echo "source $$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" >> $$HOME/.zprofile; tset; }

update:
	home-manager switch --flake .

import-gpg-key:
	eval $(op signin --account my) && op document get "Personal GPG Key" | base64 --decode | gpg --import --allow-secret-key-import --import-options restore

clean:
	nix-collect-garbage -d
