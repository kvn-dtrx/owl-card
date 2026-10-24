# dia:file makefile/latex-package.mk

# ---
# title: Makefile for LaTeX packages (TEXMFHOME/tex/latex)
# ---

# ---

# Make targets follow paradigmata (install = TEXMF deploy).
# Each directory src/<pkg>/ is installed as TEXMFHOME/tex/latex/<pkg>.
# Skips src/packages/ and src/wire/ (Python / installer trees, not TDS packages).

SRC := $(CURDIR)/src

.PHONY: help install ln cp rm

help: ## Displays available targets with description
	@bin/make-help.sh

install: ln ## Symlinks packages into TEXMFHOME/tex/latex

ln: ## Symlinks each src/<pkg> into TEXMFHOME/tex/latex
	@set -e; \
	texmfhome="$$(kpsewhich -var-value=TEXMFHOME)"; \
	[ -n "$${texmfhome}" ] || { printf 'kpsewhich did not return TEXMFHOME\n' >&2; exit 1; }; \
	[ -d "$(SRC)" ] || { printf 'Missing %s\n' "$(SRC)" >&2; exit 1; }; \
	dst="$${texmfhome}/tex/latex"; \
	mkdir -p "$${dst}"; \
	for package in "$(SRC)"/*/; do \
		[ -d "$${package}" ] || continue; \
		name="$$(basename "$${package}")"; \
		case "$${name}" in packages|wire) continue ;; esac; \
		src="$${package%/}"; \
		if [ -L "$${dst}/$${name}" ] || [ -f "$${dst}/$${name}" ]; then \
			rm -f -- "$${dst}/$${name}"; \
		elif [ -e "$${dst}/$${name}" ]; then \
			printf 'Path already occupied: %s/%s\n' "$${dst}" "$${name}" >&2; \
			exit 1; \
		fi; \
		ln -sfn "$${src}" "$${dst}/$${name}"; \
		printf 'symlinked %s/%s -> %s\n' "$${dst}" "$${name}" "$${src}"; \
	done

cp: ## Copies each src/<pkg> into TEXMFHOME/tex/latex
	@set -e; \
	texmfhome="$$(kpsewhich -var-value=TEXMFHOME)"; \
	[ -n "$${texmfhome}" ] || { printf 'kpsewhich did not return TEXMFHOME\n' >&2; exit 1; }; \
	[ -d "$(SRC)" ] || { printf 'Missing %s\n' "$(SRC)" >&2; exit 1; }; \
	dst="$${texmfhome}/tex/latex"; \
	mkdir -p "$${dst}"; \
	for package in "$(SRC)"/*/; do \
		[ -d "$${package}" ] || continue; \
		name="$$(basename "$${package}")"; \
		case "$${name}" in packages|wire) continue ;; esac; \
		src="$${package%/}"; \
		rm -rf -- "$${dst}/$${name}"; \
		cp -R "$${src}" "$${dst}/$${name}"; \
		printf 'copied %s/%s <- %s\n' "$${dst}" "$${name}" "$${src}"; \
	done

rm: ## Removes installed packages named like src/*/ from TEXMF
	@set -e; \
	texmfhome="$$(kpsewhich -var-value=TEXMFHOME)"; \
	[ -n "$${texmfhome}" ] || { printf 'kpsewhich did not return TEXMFHOME\n' >&2; exit 1; }; \
	dst="$${texmfhome}/tex/latex"; \
	for package in "$(SRC)"/*/; do \
		[ -d "$${package}" ] || continue; \
		name="$$(basename "$${package}")"; \
		case "$${name}" in packages|wire) continue ;; esac; \
		rm -rf -- "$${dst}/$${name}"; \
		printf 'removed %s/%s\n' "$${dst}" "$${name}"; \
	done
