# ---
# title: justfile for owl-card
# ---

# ---

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

tex := "tex"

# Shows available recipes
default:
    @just --list --unsorted

# Fills template with supplied data
render:
    ./scripts/render.py --template config/main.tex.j2 --output-dir {{tex}} config/specs.yaml

# Compiles filled templates
compile:
    cd {{tex}} && latexmk

# Render then compile
build: render compile

# Removes intermediate compilation files
clean:
    cd {{tex}} && latexmk -c

# Resets build artefacts and filled templates
reset:
    cd {{tex}} && latexmk -C
    find {{tex}} -mindepth 1 -iname "*.tex" -delete

# Resets then rebuilds
rebuild: reset build
