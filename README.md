# zsh-snippets

Persistent zsh-snippets based on [1ambda/zsh-snippets](https://github.com/1ambda/zsh-snippets)

- add, udpate, delete, list snippets
- supports auto-completion

![](https://github.com/1ambda/zsh-snippets/blob/master/images/usage_high.gif)

## Install: zplug

Setup aliases and widgets while binding keys with them
- `CTRL-[SPACE]` expands the specified snippet
- `CTRL-Z` lists existing snippets

```bash
# in .zshrc
zplug "verboze/zsh-snippets"
alias zsp="zsh_snippets"
bindkey '^ ' zsh-snippets-widget-expand  # CTRL-[SPACE] (expand)
bindkey '^Z' zsh-snippets-widget-list    # CTRL-Z (list)
bindkey '^N' jump_to_tabstop_in_snippet  # CTRL-N (jump to tabstop)
```

## Usage

All commands and snippets are auto-completed by stroking `tab` key

```bash
# add a `gj` snippet
# tip: you could add these into your zshrc if you wish
$ zsp --add gj "| grep java | grep -v grep"

# list snippets
# or type binded key `^Z` (CTRL+Z)
$ zsp --list

# expand a snippet
# '!' means your current cursor in terminal, type your binded key `^ ` (CTRL+[SPACE])
# note: spaces after the keyword will be removed, so the two below are equivalent
$ ps -ef gj!
$ ps -ef gj  !

# will be expanded into
$ ps -ef | grep java | grep -v grep

# jump to a "tabstop" in the snippet (tabstops are defined with `${\w+}`)
# NOTE: ! is the current cursor position in the lines below
$ zsp --add echotest 'echo "${msg1}" "${msg2}"'!
$ echotest! # expand the snippet to...
$ echo "${msg1}" "${msg2}"! # now hit CTRL-N. line becomes:
$ echo "!" "${msg2}" # the cursor is now positioned where the tabstop was, with the tabstop ${msg1} deleted
$ echo "text that I typed!" "${msg2}" # type some text, and hit CTRL-N again. Line becomes:
$ echo "text that I typed" "!"

# NOTE: when jumping to tabstops, the cursor can be anywhere on the line. We will always jump to the leftmost tabstop

# delete a snippet
zsp --delete gj
```

## Development

Load local zsh-snippets

```bash
# in .zshrc
zplug "$SOMEWHERE/zsh-snippets", from:local, use:'snippets.plugin.zsh'
```

## License

MIT
