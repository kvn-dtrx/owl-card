# Owl Card

## Synopsis

This repository contains a custom business card template written in LaTeX. A principal feature is that it permits the storage of a vCard containing various contact details within a QR code, facilitating convenient sharing.

**NOTE:** Precompiled PDF versions of this template are provided in the Releases section for ease of use.

### Nomen est … nomen

The card itself bears no relation to owls. The project's name derives merely from the circumstance that, in its initial drafts, a colour palette similar to [beamercolortheme-owl](https://github.com/rchurchley/beamercolortheme-owl) was used.

## Requirements

The compilation of the source files necessitates a LaTeX distribution such as TeXLive (≥ 2020). Moreover, populating the template file requires a Python 3 environment in which the `jinja` module is installed.

## Setup

Having navigated to a directory of your choosing, you may clone (and enter) this project using the following command:

``` shell
git clone https://github.com/kvn-dtrx/owl-talk.git &&
    cd owl-talk
```

## Usage

Within the directory `config`, one shall find the following files:

- `specs.yaml`: This file supplies the variants of contact information with which the business cards, particularly the embedded QR code, shall be populated.
- `main.tex.j2`: In this file the user may adjust the colour settings.

Once customisation is complete, you may compile the template by executing the command `make build`.

## Colophon

**Author:** [kvn-dtrx](https://github.com/kvn-dtrx)

**License:** [MIT License](license.txt)
