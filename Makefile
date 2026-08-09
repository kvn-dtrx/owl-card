# ---
# title: Makefile for owl-card (TEXMF via make-wire tex)
# ---

# ---

# Make targets follow paradigmata (install = TEXMF deploy).

XDG_DATA_HOME ?= $(HOME)/.local/share
WIRE := $(CURDIR)/bin/make-wire.bash

.PHONY: help install cp ln rm

help: ## Displays available targets with description
	@bin/make-help.sh

install: ln ## Symlink packages into TEXMF (make-wire tex)

ln: ## Symlink packages into TEXMFHOME/tex/latex
	@WIRE_MODE=symlink bash "$(WIRE)" tex "$(CURDIR)"

cp: ## Copy packages into TEXMFHOME/tex/latex
	@WIRE_MODE=copy bash "$(WIRE)" tex "$(CURDIR)"

rm: ## Remove installed packages named like src/wire/*/ from TEXMF
	@dst="$$(kpsewhich -var-value=TEXMFHOME)/tex/latex"; \
	for package in src/wire/*/; do \
		rm -rf "$${dst}/$$(basename "$${package}")"; \
		printf 'removed %s/%s\n' "$${dst}" "$$(basename "$${package}")"; \
	done
