# ---
# title: justfile for owl-card
# ---

# ---

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

root := justfile_directory()
latexmkrc := root / ".latexmkrc"
examples := root / "examples"
build-dir := "build"

# Shows available recipes
default:
    @just --list --unsorted

# Prepares build directory
prepare:
    mkdir -p {{build-dir}}

# Fills template with supplied data into examples/<slug>/main.tex
render:
    ./bin/render.py --template config/main.tex.j2 --output-dir examples examples/specs.yaml

# Compiles all examples/<slug>/main.tex into build/<slug>.pdf
compile: prepare
    #!/usr/bin/env bash
    shopt -s nullglob
    for main in "{{examples}}"/*/main.tex; do
        slug="$(basename "$(dirname "${main}")")"
        latexmk -cd -r "{{latexmkrc}}" -jobname="${slug}" "${main}"
    done

# Render then compile
build: render compile

# Removes intermediate files; keeps pdf/png/tex
clean:
    find {{build-dir}} -mindepth 1 \
        ! \( -iname "*.pdf" -o -iname "*.png" -o -iname "*.tex" -o -iname ".gitkeep" \) \
        -delete

# Wipes build directory except .gitkeep
reset:
    find {{build-dir}} -mindepth 1 ! -iname ".gitkeep" -delete

# Resets and rebuilds examples
rebuild: reset build
