SHELL := /bin/bash

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

save-dconf: ## Save dconf settings to .config/dconf/settings.dconf
	# dconf dump /org/gnome/ > ~/.config/dconf/settings.dconf
	dconf dump /com/gexperts/Tilix/ > .config/dconf/tilix.dconf
	dconf dump /org/gnome/terminal/ > .config/dconf/terminal.dconf

save-vsce: ## Save a list of VSC extensions to .config/Code/extensions.txt
	code --list-extensions | xargs -L 1 echo install > ~/.config/Code/extensions.txt

save: save-dconf save-vsce ## Update dconf and vsc extensions files

update: ## Do apt upgrade and autoremove
	sudo apt update && sudo apt upgrade -y
	sudo apt autoremove -y

