# Live Reference

LiveRefs is a lightweight Vim plugin that gives you "find references under cursor" functionality, similar to what you’d get in VSCode or smth, but powered entirely by Vimscript and built-in popups.  

When your cursor rests on a word, live-reference scans the current buffer for other occurrences of that word (ignoring keywords, comments, and trivial words) and displays them in a floating popup.  
You can then jump to a reference with the corresponding number key.

## Features

- Automatically shows references to the word under cursor (on `CursorHold`).
- Ignores comments, language keywords, and common words.
- Popup window with references displayed and clickable/jumpable.
- Press a number key (`1`–`9`) to jump to a reference directly.
- Configurable word length, max results, and update timing.
- Simple toggle to enable/disable.

## Installation

Use your favorite plugin manager. Example with vim-plug:

```vim
Plug 'saltytine/live-reference'
```

Reload Vim and run `:PlugInstall`.

## Usage

* Move the cursor onto a word and wait (`CursorHold` triggers after `updatetime` ms).
* A popup will appear listing other references in the buffer.
* Press `1`–`9` to jump to a reference, or `<Esc>` / `;` to close the popup.
* Popup closes automatically when you move, insert text, or leave the window.

## Commands

* `:LiveRefsToggle` — Enable/disable LiveRefs.
* `:LiveRefsShow` — Manually trigger reference lookup.
* Mapping: `<leader>lr` — Toggles LiveRefs (default mapping).

## Configuration

You can tweak the behavior via globals in your `vimrc`:

```vim
let g:live_refs_enabled = 1        " Enable by default (1/0)
let g:live_refs_min_word_len = 3   " Minimum word length to consider
let g:live_refs_max_results = 10   " Max number of results in popup
let g:live_refs_updatetime = 700   " CursorHold trigger time (ms)
```

## Ignored

* Comments (`//`, `#`, `/* ... */`, etc, detected via syntax groups).
* Common English words (`the`, `is`, `and`, …).
* Language keywords for many languages (C, C++, Python, JS, Rust, Go, Swift, Vimscript, etc).
* Short all-uppercase constants (`FOO`, `BAR`).
* TODO/FIXME/NOTE/WARNING tags.
* Preprocessor directives.
