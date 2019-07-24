
PREFIX ?= $(HOME)/.local

SCRIPT_TARGET = $(PREFIX)/bin
CONFIG_TARGET = $(HOME)/.config/rofi

install:
	@cp rofi-wifi-menu.sh $(SCRIPT_TARGET); \
		[ ! -f $(CONFIG_TARGET)/wifi ] \
			&& cp config.example $(CONFIG_TARGET)/wifi \
			|| echo "Found existing config skipping copying config"

uninstall:
	rm $(SCRIPT_TARGET)/rofi-wifi-menu.sh

mkdirs:
	@mkdir $(SCRIPT_TARGET); \
		mkdir $(CONFIG_TARGET)
