#!/usr/bin/env python3

# ---
# description: >-
#   Renders LaTeX template from YAML data
# ---

# ---

import argparse
from pathlib import Path

import yaml
from jinja2 import Environment, FileSystemLoader


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("yaml_file", help="YAML file with multiple entries")
    parser.add_argument("--template")
    parser.add_argument("--output-dir")
    args = parser.parse_args()

    with open(args.yaml_file, encoding="utf-8") as f:
        specs = yaml.safe_load(f)

    env = Environment(
        loader=FileSystemLoader("."),
        block_start_string="<BLOCK>",
        block_end_string="</BLOCK>",
        variable_start_string="<VAR>",
        variable_end_string="</VAR>",
        comment_start_string="<COMMENT>",
        comment_end_string="</COMMENT>",
        trim_blocks=True,
        lstrip_blocks=True,
    )

    template = env.get_template(args.template)

    Path(args.output_dir).mkdir(parents=True, exist_ok=True)

    for spec in specs:
        if "pgpkey" in spec and spec["pgpkey"]:
            spec["pgpkey"] = spec["pgpkey"].replace("\n", "^^J")
        for k in spec:
            # ENIGMA: How to force qrcode to print blank characters?
            spec[k] = spec[k].replace(" ", "~")
        name = spec["description"].lower().replace(" ", "-")
        slug_dir = Path(args.output_dir) / name
        slug_dir.mkdir(parents=True, exist_ok=True)
        output_path = slug_dir / "main.tex"
        output_path.write_text(template.render(**spec), encoding="utf-8")


if __name__ == "__main__":
    main()
