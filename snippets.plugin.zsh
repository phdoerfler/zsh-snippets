#!/usr/bin/env zsh

# TODO: optional fzf to select snippets when no input is provided
#       pull functionality from Shea690901/zsh-snippets

## initialize snippet history file
SNIPPET_FILE=~/.zsh_snippets
typeset -Ag zshSnippetArr

ZSH_SNIPPETS_VERSION="1"
TAG="ZSH_SNIPPETS"

_clean_zsh_snippets() {
    zshSnippetArr=()
    # serialize current snippets to file
    typeset -p zshSnippetArr >! $SNIPPET_FILE
}

## init
if [ ! -e "$SNIPPET_FILE" ]; then
    $(which touch) $SNIPPET_FILE
    $(which chmod) +x $SNIPPET_FILE
    _clean_zsh_snippets
fi

## util functions
log_info() {
    if [[ $DEBUG > 0 ]]; then
        local message; message=$1
        echo "[$TAG] INFO - $message"
    fi
}

## snippet related functions
_show_zsh_snippets_version() {
    echo $ZSH_SNIPPETS_VERSION
}

_show_zsh_snippets_file() {
    echo $SNIPPET_FILE
}

_add_zsh_snippets() {
    if [ $# -lt 2 ]; then
        echo "Usage: _add_zsh_snippets <key> <value>"
        return 1
    fi

    source $SNIPPET_FILE
    zshSnippetArr[$1]="$2"
    typeset -p zshSnippetArr >! $SNIPPET_FILE
}

_delete_zsh_snippets() {
    if [ $# -lt 1 ]; then
        echo "Usage: _delete_zsh_snippets <key>"
        return 1
    fi

    source $SNIPPET_FILE
    unset "zshSnippetArr[$1]"
    typeset -p zshSnippetArr >! $SNIPPET_FILE
}

_list_zsh_snippets() {
    source $SNIPPET_FILE
    local snippetList="$(print -a -C 2 ${(kv)zshSnippetArr})"

    echo "$snippetList"
}

jump_to_tabstop_in_snippet() {
    # the idea is to match ${\w+}, and replace
    # that with the empty string, and move the cursor to
    # beginning of the match. If no match found, simply return
    # valid place holders: ${}, ${somealphanumericstr}
    local str=$BUFFER
    local searchstr=''
    [[ $str =~ ([$]\\{[[:alnum:]]*\\}) ]] && searchstr=$MATCH
    [[ -z "$searchstr" ]] && return

    local rest=${str#*$searchstr}
    local pos=$(( ${#str} - ${#rest} - ${#searchstr} ))
    BUFFER=$(echo ${str//${MATCH}/})
    CURSOR=$pos
}
zle -N jump_to_tabstop_in_snippet

zsh-snippets-widget-list() {
    source $SNIPPET_FILE
    local snippetList="$(print -a -C 2 ${(kv)zshSnippetArr})"
    zle -M "$snippetList"
}
zle -N zsh-snippets-widget-list

zsh-snippets-widget-expand() {
    emulate -L zsh
    setopt extendedglob
    local MATCH
    # trim spaces from match

    # _read_zsh_snippets
    source $SNIPPET_FILE

    # http://stackoverflow.com/questions/20832433/what-does-lbufferm-a-za-z0-9-do-in-zsh
    LBUFFER=${LBUFFER%%[[:blank:]]##}            # remove trailing spaces
    LBUFFER=${LBUFFER%%(#m)[.\-+:|_a-zA-Z0-9]#}  # retrieve last word on the line
    LBUFFER+="${zshSnippetArr[$MATCH]:-$MATCH}"  # return expansion value or word if no match

    zle -M "" # clean screen after snippet expansion
}
zle -N zsh-snippets-widget-expand

## command handler
zsh_snippets() {
    local cmd; cmd=$1
    local shortcut; shortcut=$2
    local snippet; snippet=$3
    local helpmsg

    helpmsg="Usage: $0 [add|delete|list]"
    helpmsg="$helpmsg\n       $0 -a <snippet> <expansion>"
    helpmsg="$helpmsg\n       $0 -d <snippet>"

    case $cmd in
        add)
            _add_zsh_snippets $shortcut $snippet
            [[ $? = 0 ]] && log_info "'$shortcut' snippet is added"
        ;;
        delete)
            _delete_zsh_snippets $shortcut
            [[ $? = 0 ]] && log_info "'$shortcut' snippet is deleted"
        ;;
        list)
            _list_zsh_snippets
        ;;
        *)
            echo -e $helpmsg
        ;;
    esac
}

## add completion file to fpath
fpath+="`dirname $0`"
