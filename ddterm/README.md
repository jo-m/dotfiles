# ddterm Color Themes

Manage ddterm drop-down terminal color themes via `ddterm-theme.py`.

## Usage

```bash
./ddterm-theme.py -h
```

Themes are stored in `themes.json`.

## Creating a New Theme

### Theme structure

Each theme in `themes.json` has four fields:

```json
{
  "my-theme": {
    "foreground-color": "#ebdbb2",
    "background-color": "#282828",
    "background-opacity": 0.82,
    "palette": [
      "#282828", "#cc241d", "#98971a", "#d79921",
      "#458588", "#b16286", "#689d6a", "#a89984",
      "#928374", "#fb4934", "#b8bb26", "#fabd2f",
      "#83a598", "#d3869b", "#8ec07c", "#ebdbb2"
    ]
  }
}
```

### Palette indices

The 16-color palette maps to standard ANSI terminal colors:

| Index | Normal colors      | Index | Bright colors       |
|------:|--------------------|------:|---------------------|
|     0 | black              |     8 | bright black (gray) |
|     1 | red                |     9 | bright red          |
|     2 | green              |    10 | bright green        |
|     3 | yellow             |    11 | bright yellow       |
|     4 | blue               |    12 | bright blue         |
|     5 | magenta            |    13 | bright magenta      |
|     6 | cyan               |    14 | bright cyan         |
|     7 | white              |    15 | bright white        |

### Workflow

The easiest way to create a theme is interactively:

1. Open ddterm (F8) and tweak colors in its preferences UI.
2. Once satisfied, store the result:
   ```bash
   ./ddterm-theme.py store my-new-theme
   ```
3. Commit the updated `themes.json`.

Alternatively, copy a palette from a well-known terminal theme (e.g. from
<https://terminal.sexy> or <https://gogh-co.github.io/Gogh/>) and add it
to `themes.json` by hand.

## Color Contrast Requirements

The terminal background is dark (near-black) with **partial opacity**
(`background-opacity` around 0.8–0.9), so whatever is behind the terminal
window bleeds through. This means colors that are merely "dark" can become
hard to read depending on the desktop wallpaper.

### Fish syntax highlighting (`colors.fish`)

Fish syntax highlighting uses **named ANSI colors** (not hardcoded hex), so
the palette you choose directly controls what these look like:

| Fish color variable         | ANSI color used | Palette index |
|-----------------------------|-----------------|:-------------:|
| `fish_color_normal`         | white           | 7             |
| `fish_color_command`        | white **bold**  | 7             |
| `fish_color_quote`          | yellow          | 3             |
| `fish_color_redirection`    | cyan **bold**   | 6 / 14        |
| `fish_color_end`            | green           | 2             |
| `fish_color_error`          | bright red      | 9             |
| `fish_color_comment`        | bright black    | 8             |
| `fish_color_operator`       | bright cyan     | 14            |
| `fish_color_escape`         | bright cyan     | 14            |
| `fish_color_autosuggestion` | bright black    | 8             |
| `fish_color_cwd`            | green           | 2             |
| `fish_color_search_match`   | bright yellow bg on bright black | 11 / 8 |

**Contrast rules for the palette:**

- **Palette 7 (white)** is the default text color. It *must* be clearly
  legible on the background color at the chosen opacity. Aim for a
  luminance contrast ratio of at least **4.5:1** against the background.
- **Palette 8 (bright black / gray)** is used for comments and
  autosuggestions. It should be *visible but subdued* — readable if you
  focus on it, but clearly dimmer than normal text. Too dark and comments
  vanish; too bright and they compete with code.
- **Palette 3 (yellow)** is used for quoted strings. Must stand out from
  both the foreground (white) and the background.
- **Palette 2 (green)** and **palette 6 (cyan)** are used for shell syntax.
  They need to be distinguishable from each other and from white.
- **Palette 1 (red) / 9 (bright red)** are used for errors. Should be
  unmistakably different from greens and yellows.

### Tide prompt (`tide_config.fish`)

The tide prompt uses ANSI named colors for segment backgrounds and
foregrounds. The relevant mappings:

| Prompt segment      | Background  | Foreground | Palette indices |
|----------------------|-------------|------------|:---------------:|
| Status / jobs / etc. | black       | yellow     | 0, 3            |
| Username             | blue        | white      | 4, 7            |
| Hostname             | yellow      | black      | 3, 0            |
| PWD                  | green       | white      | 2, 7            |
| Git                  | red         | white      | 1, 7            |
| Direnv / Rust / etc. | white       | black      | 7, 0            |
| Cmd duration         | yellow      | black      | 3, 0            |
| Status (failure)     | red         | white      | 1, 7            |
| Prompt character     | —           | yellow     | —, 3            |

**Contrast rules for tide segments:**

- **White (7) on blue (4):** The blue must be dark/saturated enough that
  white text is legible on it. Avoid pastel blues.
- **White (7) on green (2):** Same — green should be a medium-to-dark
  saturated green rather than lime/pastel.
- **White (7) on red (1):** Red should be a strong, saturated red.
- **Black (0) on yellow (3):** Yellow must be bright enough that dark text
  is readable. Avoid brownish/muddy yellows.
- **Black (0) on white (7):** This only works if palette 0 is truly dark
  and palette 7 is truly light.

### Quick checklist

Before committing a new theme, verify:

- [ ] Default text (palette 7, `foreground-color`) is clearly readable on
      the background at the configured opacity with your usual wallpaper.
- [ ] Comments/autosuggestions (palette 8) are visible but obviously dimmer
      than normal text.
- [ ] All six standard colors (1–6) are distinguishable from each other and
      from the background.
- [ ] Tide prompt segments are legible: white-on-blue, white-on-green,
      white-on-red, black-on-yellow.
- [ ] Bright colors (9–14) are distinguishable from their normal variants.
- [ ] The `foreground-color` value roughly matches or complements palette 7.
