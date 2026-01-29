#!/bin/bash

_notenwart_completions()
{
    # Need at least: "notenwart <something>"
    [ "${#COMP_WORDS[@]}" -gt 1 ] || return

    local action last_word arguments
    last_word="${COMP_WORDS[$(( ${#COMP_WORDS[@]} - 1 ))]}"
    action="${COMP_WORDS[1]}"

    # Default completion is action names
    arguments="$( notenwart actions )"

    # If completing the action itself (2nd word)
    if [ "${#COMP_WORDS[@]}" -eq 2 ]; then
        COMPREPLY=($(compgen -W "$arguments" "$last_word"))
        return
    fi

    # From here on, we're completing action args
    case "$action" in
        list)
            # no args
            arguments=""
            ;;
        create)
            # repo_name is free-form; don't suggest existing ones
            arguments=""
            ;;
        delete)
            case "${#COMP_WORDS[@]}" in
                3)
                    # repo_name
                    arguments="$( notenwart list )"
                    ;;
                *)
                    # suggest -f after repo_name (or anytime after)
                    arguments="-f"
                    ;;
            esac
            ;;
        rename)
            case "${#COMP_WORDS[@]}" in
                3)
                    # old_name
                    arguments="$( notenwart list )"
                    ;;
                4)
                    # new_name is free-form; no suggestions
                    arguments=""
                    ;;
                *)
                    arguments=""
                    ;;
            esac
            ;;
        describe)
            case "${#COMP_WORDS[@]}" in
                3)
                    # repo_name
                    arguments="$( notenwart list )"
                    ;;
                *)
                    # description is free-form; no suggestions
                    arguments=""
                    ;;
            esac
            ;;
        import)
            case "${#COMP_WORDS[@]}" in
                3)
                    # repo_name is free-form
                    arguments=""
                    ;;
                4)
                    # remote_url is free-form
                    arguments=""
                    ;;
                *)
                    # options after the required args
                    arguments="-m -d="
                    ;;
            esac
            ;;
        actions)
            # clavichord built-in: -d for descriptions
            arguments="-d"
            ;;
        *)
            arguments=""
            ;;
    esac

    [ "$arguments" == "" ] && return
    COMPREPLY=($(compgen -W "$arguments" "$last_word"))
}

complete -o nospace -F _notenwart_completions notenwart
