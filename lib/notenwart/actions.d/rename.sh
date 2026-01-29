set_action "rename" "old_name new_name"                                       \
"Rename an existing repository"                                               \
"Usage:"                                                                      \
"  %program_name% %action_name% %old_name% %new_name%"                        \
""

rename(){(
    old="$1"
    new="$2"

    [[ "$old" == *.git ]] || old="${old}.git"
    [[ "$new" == *.git ]] || new="${new}.git"

    if [[ ! "$old" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $old"
      return 1
    fi

    if [[ ! "$new" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $new"
      return 1
    fi

    old_path="$git_repositories/$old"
    new_path="$git_repositories/$new"

    if [ ! -d "$old_path" ]; then
        echo "ERROR: Repository does not exist: $old"
        return 1
    fi

    if [ -e "$new_path" ]; then
        echo "ERROR: Target repository already exists: $new"
        return 1
    fi

    sudo mv "$old_path" "$new_path" || return 1
    sudo chown -R "$git_user:$git_user" "$new_path"

    echo "Repository renamed: $old → $new"
    echo "NOTE: Clients must update their remote URLs."
)}

