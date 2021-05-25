# zsh-snippets

Persistent zsh-snippets based on [verboze/zsh-snippets](https://github.com/verboze/zsh-snippets)

- add, update, delete, list snippets
- supports auto-completion

![](https://github.com/phdoerfler/zsh-snippets/blob/master/images/usage_high.gif)

👆 Note: This GIF is slightly out of date, it's from the OG repository.

## Install

git clone to some directory

<pre>
# in .zshrc
source /where/you/cloned/the/repository/to/snippets.plugin.zsh
alias zsp="zsh_snippets"
bindkey '^ ' zsh-snippets-widget-expand  # <kbd>Ctrl</kbd>+<kbd>SPACE</kbd> (expand)
bindkey '^Z' zsh-snippets-widget-list    # <kbd>Ctrl</kbd>+<kbd>Z</kbd> (list)
bindkey '^N' jump_to_tabstop_in_snippet  # <kbd>Ctrl</kbd>+<kbd>N</kbd> (jump to tabstop)
</pre>

``` BASH
exec zsh # to "reload" your zsh
```


## Usage

<pre>
# add a `gj` snippet
$ zsp add gj "| grep java | grep -v grep"

# list snippets
# or type binded key `^Z` (<kbd>Ctrl</kbd>+<kbd>Z</kbd>)
$ zsp list

# expand a snippet
# type your binded key `^ ` (<kbd>Ctrl</kbd>+<kbd>Space</kbd>)
# note: spaces after the keyword will be removed, so the two below are equivalent
$ ps -ef gj<<kbd>Ctrl</kbd>+<kbd>Space</kbd>>
$ ps -ef gj  <<kbd>Ctrl</kbd>+<kbd>Space</kbd>>

# will be expanded into
$ ps -ef | grep java | grep -v grep

# jump to a "tabstop" in the snippet (tabstops are defined with `${\w+}`)
$ zsp add echotest 'echo "${msg1}" "${msg2}"'!
$ echotest<<kbd>Ctrl</kbd>+<kbd>Space</kbd>> # expand the snippet to...
$ echo "${msg1}" "${msg2}"! # now hit <kbd>Ctrl</kbd>+<kbd>N</kbd>. line becomes:
$ echo "!" "${msg2}" # the cursor is now positioned where the tabstop was, with the tabstop ${msg1} deleted
$ echo "text that I typed!" "${msg2}" # type some text, and hit <kbd>Ctrl</kbd>+<kbd>N</kbd> again. Line becomes:
$ echo "text that I typed" "!"

# NOTE: when jumping to tabstops, the cursor can be anywhere on the line. We will always jump to the leftmost tabstop

# delete a snippet
zsp delete gj

# Quoting
zsp add red "ruby -e 'while gets(); \${code}; puts \$_ end'"

</pre>

## License

MIT
