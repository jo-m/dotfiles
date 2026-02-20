// Design inspired by https://resources.jetbrains.com/storage/products/clion/docs/CLion_ReferenceCard.pdf

#let docTitle = "Personal Keyboard Cheatsheet"

#set document(title: docTitle, author: "jo-m.ch")

#set page(paper: "a4", flipped: true, margin: 3em)

#set text(font: "Brandon Grotesque", size: 9pt, weight: 400)
#set strong(delta: 100)
#show heading.where(level: 1): set text(size: 15pt)
#show heading.where(level: 2): set text(size: 9pt)

// TODO:
// - Heading
// - Breaks with repeating heading
// - Align at bottom

#let shortcut_section(title, items) = {
  grid(
    columns: (2fr, 1fr),
    inset: (y: 0.6em),
    column-gutter: 2em,
    grid.cell(
      colspan: 2,
      heading(level: 2, upper(title)),
    ),
    grid.hline(stroke: 1.5pt + black),
    ..items
      .map(pair => (
        // Description
        text(pair.at(0)),
        // Shortcut
        strong(text(pair.at(1))),
        // Separator
        grid.hline(stroke: 0.5pt + black),
      ))
      .flatten(),
  )
  v(1em)
}

#columns(3, gutter: 5em)[
  #heading(level: 1, docTitle)
  #v(1em)

  // Keyboard keymap:
  // https://github.com/jo-m/qmk_firmware/blob/jo-m/keyboards/keebio/quefrency/keymaps/jo_m_rev3/keymap.c
  // https://github.com/jo-m/qmk_firmware/blob/jo-m/keyboards/keebio/quefrency/keymaps/jo_m_rev1/macros.h

  #shortcut_section("Symbols", (
    ("Compose Key", "Caps Lock"),
    ("Degree °", "Compose O O"),
    ("Grave `", "Fn + ESC"), // Keyboard custom.
    ("Grave `", "Fn + ]"), // Keyboard custom.
    ("Tilde ~", "Shift + ESC"), // Keyboard custom.
  ))

  #shortcut_section("Window Manager", (
    ("Show Desktop", "Super + D"),
    ("Search", "Ctrl + Space"),
    ("File manager", "F1, Fn + 1"),
    ("Switch to dark theme", "F6, Fn + 6"),
    ("IDE", "F7, Fn + 7"),
    ("Terminal", "F8, Fn + 8"),
    ("Chrome", "F9, Fn + 9"),
    ("Firefox", "F10, Fn + 0"),
    ("Move Window", "Super + LMB"),
    ("Resize Window", "Super + RMB"),
  ))

  #shortcut_section("Shell readline", (
    // ("Move to start of line", "Home, Fn + ←"),
    // ("Move to end of line", "End, Fn + →"),
    // ("Move backward one word", "Ctrl + ←"),
    // ("Move forward one word", "Ctrl + →"),
    ("Delete to start of line", "Ctrl + U"),
    ("Delete to end of line", "Ctrl + K"),
    ("Delete previous word", "Ctrl + W"),
    ("Page UP, DOWN", "Fn + ↑, Fn + ↓"),
    ("HOME, END", "Fn + ←, Fn + →"),
  ))

  #shortcut_section("VSCodium", (
    ("Insert ISO date", "Ctrl + ;"),
  ))

  #colbreak()

  #shortcut_section("Shell scripts", (
    ("Jump", "z"),
    // ("mkdir + cd", "md"),
    ("mv with lineedit", "mvv"),
    // ("Gnome Trash", "trash"),
    ("Clipboard — Copy", "copy"),
    ("Clipboard — Paste", "pasta"),
    ("Clipboard — Keep pasting", "pastas"),
    ("Find emoji", "emoji <kw>"),
    ("Memoize output", "memo <cmd>"),
    // ("Nato spell", "nato <words>"),
    ("Dissect URL", "url <url>"),
    ("Ultimate Plumber", "|& up"),
    ("Interactive tree view", "broot"),
    ("Drag files in/out of terminal", "blobdrop"),
  ))

  #shortcut_section("Shell fzf shortcuts", (
    ("Search files", "Ctrl + T"),
    ("Search history", "Ctrl + R"),
    ("cd", "Alt + C, fcd"),
    ("Virtualenv", "venv"),
    ("SSH", "fssh"),
    ("IDE — Open files", "fc"),
    ("IDE — Open recent files", "fode"),
    ("Git — Delete branch", "fdelb"),
    ("Git — Clean up branches", "fcleanb"),
    ("Git — Checkout branch", "fco"),
    ("fzf-make", "fmake"),
  ))

  #colbreak()

  #shortcut_section("Tmux", (
    ("Prefix", "Ctrl + B"),
    ("Toggle statusbar", "Prefix + S"),
    // ("Create Window", "Prefix + C"),
    ("Next Window", "Prefix + N"),
    ("Previous Window", "Prefix + P"),
    // ("Find Window", "Prefix + F"),
    // ("Name Window", "Prefix + ,"),
    ("Kill Window", "Prefix + &"),
    ("Swap Panes", "Prefix + O"),
    ("Show Pane Numbers", "Prefix + Q"),
    ("Kill Pane", "Prefix + X"),
    ("Create Window", "Fn + C"), // Keyboard custom.
    ("Zoom Window", "Fn + Z"), // Keyboard custom.
  ))



  #shortcut_section("Tmux Copy Mode", (
    ("Start Copy Mode", "Prefix + ["),
    ("Start Selection", "Space"),
    ("Clear Selection", "Esc"),
    ("Copy Selection", "Enter"),
    ("Paste Buffer", "Prefix + ]"),
    ("Cursor to Bottom Line", "L"),
    ("Cursor to Middle Line", "M"),
    ("Cursor to Top Line", "H"),
    ("Goto Line", ":"),
    // ("Quit Mode", "q"),
    ("Search Again", "n"),
    ("Search Backward", "?"),
    ("Search Forward", "/"),
  ))





  // TODO: VSCode shortcuts symlinked/vscode/keybindings.json
]
