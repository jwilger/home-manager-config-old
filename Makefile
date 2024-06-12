.PHONY: update
update:
	home-manager switch --flake .#jwilger

.PHONY: clean
clean:
	nix-collect-garbage -d