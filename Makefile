.PHONY: all install update check-identity test-emacs test-config help check-lisp clean

all: help

help:
	@echo "AYGP Dotfiles - Emacs/Lisp Environment"
	@echo "---------------------------------"
	@echo "make install       - Install dotfiles to home directory"
	@echo "make update        - Update and reinstall dotfiles"
	@echo "make check-identity - Validate identity configuration"
	@echo "make test-emacs    - Test Emacs configuration"
	@echo "make test-config   - Test all configurations"
	@echo "make check-lisp    - Lint Emacs Lisp files"
	@echo "make clean         - Remove backup and temporary files"

install:
	@echo "Installing dotfiles..."
	@chmod +x ./install.sh
	./install.sh

update:
	@echo "Updating dotfiles..."
	git pull
	@chmod +x ./install.sh
	./install.sh

check-identity:
	@echo "Validating identity configuration..."
	@if [ -f ./scripts/check-identity.sh ]; then \
		chmod +x ./scripts/check-identity.sh; \
		./scripts/check-identity.sh; \
	else \
		echo "Identity check script not found."; \
		exit 1; \
	fi

test-emacs:
	@echo "Testing Emacs configuration..."
	@echo "(load-file \"$(shell pwd)/editors/emacs/init.el\")" > /tmp/emacs-test.el
	@emacs --batch --load /tmp/emacs-test.el 2>&1 | grep -v "^Loading"
	@rm -f /tmp/emacs-test.el
	@echo "Emacs configuration loaded successfully."

check-lisp:
	@echo "Linting Emacs Lisp files..."
	@if command -v elint >/dev/null 2>&1; then \
		for f in $(shell find editors/emacs -name "*.el"); do \
			echo "Checking $$f"; \
			emacs --batch --load=elint --eval "(elint-file \"$$f\")" 2>&1 | grep -v "^Loading"; \
		done; \
	else \
		echo "elint not found. Skipping Lisp linting."; \
	fi

test-config:
	@echo "Testing all configurations..."
	@chmod +x ./scripts/test.sh
	./scripts/test.sh
	@$(MAKE) test-emacs

clean:
	@echo "Cleaning temporary files..."
	@find . -name "*~" -delete
	@find . -name "*.elc" -delete
	@find . -name ".#*" -delete
	@find . -name "#*#" -delete
	@echo "Temporary files removed."