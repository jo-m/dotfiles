#!/usr/bin/env python3

import subprocess
import configparser
from pathlib import Path
from typing import List


PATHS = [
    "com/github/amezin/ddterm",
    "org/gnome/desktop/input-sources",
    "org/gnome/desktop/interface",
    "org/gnome/desktop/media-handling",
    "org/gnome/desktop/peripherals/mouse",
    "org/gnome/desktop/peripherals/touchpad",
    "org/gnome/desktop/privacy",
    "org/gnome/desktop/search-providers",
    "org/gnome/desktop/session",
    "org/gnome/desktop/sound",
    "org/gnome/desktop/wm/keybindings",
    "org/gnome/desktop/wm/preferences",
    "org/gnome/mutter",
    "org/gnome/nautilus/icon-view",
    "org/gnome/nautilus/preferences",
    "org/gnome/settings-daemon/plugins/color",
    "org/gnome/settings-daemon/plugins/media-keys",
    "org/gnome/settings-daemon/plugins/power",
    "org/gnome/shell",
    "org/gnome/terminal/legacy",
    "org/gnome/tweaks",
]


def run_dconf_dump():
    result = subprocess.run(
        ["dconf", "dump", "/"], capture_output=True, text=True, check=True
    )
    return result.stdout


def parse_dconf_output(dconf_output: str):
    config = configparser.ConfigParser()
    config.read_string(dconf_output)
    return config


def filter_config(config: configparser.ConfigParser, paths: List[str]):
    filtered = configparser.ConfigParser()
    for section in config.sections():
        assert not (section.startswith("/") or section.endswith("/"))
        if any(section.startswith(p) for p in PATHS):
            filtered[section] = config[section]
    return filtered


def main():
    dconf_output = run_dconf_dump()
    config = parse_dconf_output(dconf_output)

    assert not any(p.startswith("/") or p.endswith("/") for p in PATHS)
    filtered = filter_config(config, PATHS)

    with open(Path(__file__).parent / "dconf.ini", "w") as f:
        filtered.write(f, space_around_delimiters=False)


if __name__ == "__main__":
    main()
