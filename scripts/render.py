#!/usr/bin/env python3

# ---
# description: Renders LaTeX template from YAML data
# ---

# ---

import argparse
import yaml
from pathlib import Path
from jinja2 import Environment
from jinja2 import FileSystemLoader


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
        name = spec["description"].lower().replace(" ", "_")
        output_path = Path(args.output_dir) / f"{name}.tex"
        output_path.write_text(template.render(**spec), encoding="utf-8")


if __name__ == "__main__":
    main()
