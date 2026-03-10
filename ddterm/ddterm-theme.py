#!/usr/bin/env python3
"""Manage ddterm color themes via dconf."""

import argparse
import json
import os
import re
import subprocess
import sys

DCONF_PATH = "/com/github/amezin/ddterm/"
THEMES_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "themes.json")


def hex_to_rgb(h):
    """Convert '#rrggbb' to 'rgb(r,g,b)'."""
    h = h.lstrip("#")
    return f"rgb({int(h[0:2], 16)},{int(h[2:4], 16)},{int(h[4:6], 16)})"


def rgb_to_hex(s):
    """Convert 'rgb(r,g,b)' to '#rrggbb'."""
    m = re.match(r"rgb\((\d+),(\d+),(\d+)\)", s)
    if not m:
        raise ValueError(f"Cannot parse color: {s}")
    return f"#{int(m[1]):02x}{int(m[2]):02x}{int(m[3]):02x}"


def load_themes():
    with open(THEMES_FILE) as f:
        return json.load(f)


def save_themes(themes):
    with open(THEMES_FILE, "w") as f:
        json.dump(themes, f, indent=2)
        f.write("\n")


def dconf_read(key):
    result = subprocess.run(
        ["dconf", "read", DCONF_PATH + key],
        capture_output=True, text=True
    )
    return result.stdout.strip()


def dconf_write(key, value):
    subprocess.run(
        ["dconf", "write", DCONF_PATH + key, value],
        check=True
    )


def ansi_bg(hex_color):
    """Return ANSI escape to set background to a hex color."""
    h = hex_color.lstrip("#")
    r, g, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    return f"\033[48;2;{r};{g};{b}m"


def ansi_fg(hex_color):
    """Return ANSI escape to set foreground to a hex color."""
    h = hex_color.lstrip("#")
    r, g, b = int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)
    return f"\033[38;2;{r};{g};{b}m"


RESET = "\033[0m"


def cmd_list(args):
    themes = load_themes()
    if not themes:
        print("No themes defined.")
        return

    for name, t in themes.items():
        fg = t["foreground-color"]
        bg = t["background-color"]
        palette = t["palette"]
        opacity = t.get("background-opacity", 1.0)

        # Theme name and basic info
        print(f"\n  {name}  (opacity: {opacity})")

        # Preview: theme name rendered in its own colors
        preview_text = f"  {name}  "
        print(f"  {ansi_fg(fg)}{ansi_bg(bg)} {preview_text} {RESET}")

        # Palette blocks
        top = "  "
        bottom = "  "
        for c in palette[:8]:
            top += f"{ansi_bg(c)}   {RESET}"
        for c in palette[8:]:
            bottom += f"{ansi_bg(c)}   {RESET}"
        print(top)
        print(bottom)

    print()


def cmd_load(args):
    themes = load_themes()
    name = args.theme
    if name not in themes:
        print(f"Unknown theme: {name}", file=sys.stderr)
        print(f"Available: {', '.join(themes)}", file=sys.stderr)
        sys.exit(1)

    t = themes[name]

    dconf_write("foreground-color", f"'{hex_to_rgb(t['foreground-color'])}'")
    dconf_write("background-color", f"'{hex_to_rgb(t['background-color'])}'")
    dconf_write("background-opacity", str(t.get("background-opacity", 1.0)))
    dconf_write("use-theme-colors", "false")

    palette_str = "[" + ", ".join(f"'{hex_to_rgb(c)}'" for c in t["palette"]) + "]"
    dconf_write("palette", palette_str)

    print(f"Applied theme: {name}")


def cmd_store(args):
    name = args.theme

    # Read current values from dconf
    fg_raw = dconf_read("foreground-color").strip("'")
    bg_raw = dconf_read("background-color").strip("'")
    opacity_raw = dconf_read("background-opacity")
    palette_raw = dconf_read("palette")

    fg = rgb_to_hex(fg_raw)
    bg = rgb_to_hex(bg_raw)
    opacity = float(opacity_raw) if opacity_raw else 0.8

    # Parse palette: "['rgb(...)', 'rgb(...)' ...]"
    palette_colors = re.findall(r"rgb\(\d+,\d+,\d+\)", palette_raw)
    if len(palette_colors) != 16:
        print(f"Error: expected 16 palette colors, got {len(palette_colors)}", file=sys.stderr)
        sys.exit(1)
    palette = [rgb_to_hex(c) for c in palette_colors]

    themes = load_themes()
    if name in themes and not args.force:
        print(f"Theme '{name}' already exists. Use --force to overwrite.", file=sys.stderr)
        sys.exit(1)

    themes[name] = {
        "foreground-color": fg,
        "background-color": bg,
        "background-opacity": opacity,
        "palette": palette,
    }
    save_themes(themes)
    print(f"Stored current ddterm colors as: {name}")


def main():
    parser = argparse.ArgumentParser(description="Manage ddterm color themes")
    sub = parser.add_subparsers(dest="command", required=True)

    sub.add_parser("list", help="Preview all available themes")

    p_load = sub.add_parser("load", help="Apply a theme to ddterm")
    p_load.add_argument("theme", help="Theme name")

    p_store = sub.add_parser("store", help="Store current ddterm colors as a new theme")
    p_store.add_argument("theme", help="Name for the new theme")
    p_store.add_argument("-f", "--force", action="store_true",
                         help="Overwrite existing theme")

    args = parser.parse_args()
    {"list": cmd_list, "load": cmd_load, "store": cmd_store}[args.command](args)


if __name__ == "__main__":
    main()
