set_action "rename~" "old_name new_name"                                      \
"Rename an existing repository"                                               \
"Usage:"                                                                      \
"  %program_name% %action_name% %old_name% %new_name%"                        \
""

rename(){(
    [[ "$old_name" == *.git ]] || old_name="${old_name}.git"
    [[ "$new_name" == *.git ]] || new_name="${new_name}.git"

    if [[ ! "$old_name" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $old_name"
      return 1
    fi

    if [[ ! "$new_name" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $new_name"
      return 1
    fi

    old_path="$git_repositories/$old_name"
    new_path="$git_repositories/$new_name"

    if [ ! -d "$old_path" ]; then
        echo "ERROR: Repository does not exist: $old_name"
        return 1
    fi

    if [ -e "$new_path" ]; then
        echo "ERROR: Target repository already exists: $new_name"
        return 1
    fi

    sudo mv "$old_path" "$new_path" || return 1
    sudo chown -R "$git_user:$git_user" "$new_path"

    echo "Repository renamed: $old_name → $new_name"
    echo "NOTE: Clients must update their remote URLs."
)}

