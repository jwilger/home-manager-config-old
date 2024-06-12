.PHONY: all update clean check-nix

all: check-nix update

check-nix:
	@command -v nix >/dev/null 2>&1 || { echo >&2 "Installing Nix..."; curl -L https://nixos.org/nix/install | sh -s -- --daemon; }

update:
	home-manager switch --flake .#jwilger

clean:
	nix-collect-garbage -d