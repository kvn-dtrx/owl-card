
.PHONY: help render compile build clean reset rebuild

help: ## Shows this help
	@echo "Available targets for make:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "  %-13s: %s\n", $$1, $$2}'

# ---

SRC:=$(wildcard src/*)
PACKAGES:=$(patsubst src/%,%,$(SRC))
TEXMF:=$(HOME)/Library/texmf
TARGET:=$(TEXMF)/tex/latex

ln: ## Symlinks package into TEXMF
	@mkdir -p $(TARGET)
	@for package in $(PACKAGES); do \
		ln -sf "$$(realpath src/$$package)" "$(TARGET)/"; \
	done
# 	Not strictly necessary; however, it does not harm.
	texhash "$(TEXMF)"

rm: ## Removes package from TEXMF
	@for package in $(PACKAGES); do \
		rm -r "$(TARGET)/$$(basename $$package)"; \
	done
# 	Not strictly necessary; however, it does not harm.
	texhash $(TEXMF)

# ---

TEX:=tex

render: ## Fills template with supplied data
	@./scripts/render.py --template config/main.tex.j2 --output-dir $(TEX) config/specs.yaml

compile: ## Compiles filled templates
	@cd $(TEX) && latexmk

build: render compile ## Executes render and build

clean: ## Removes intermediate compilation files
	@cd $(TEX) && latexmk -c

reset: ## Resets build directory and removes filled templates
	@cd $(TEX) && latexmk -C
	@find $(TEX) -mindepth 1 -name '*.tex' -delete

rebuild: reset render compile ## Executes reset, render and build
