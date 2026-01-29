set_action "describe" "repo_name description"                                 \
"Set the description of a git repository (used by gitweb)"                    \
"Usage:"                                                                      \
"  %program_name% %action_name% %repo_name% \"Description text\""             \
""

describe(){(
    repo_name="$1"
    shift
    description="$*"

    [[ "$repo_name" == *.git ]] || repo_name="${repo_name}.git"

    if [[ ! "$repo_name" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $repo_name"
      return 1
    fi

    repo_path="$git_repositories/$repo_name"

    if [ ! -d "$repo_path" ]; then
        echo "ERROR: Repository does not exist: $repo_name"
        return 1
    fi

    echo "$description" | sudo tee "$repo_path/description" >/dev/null
    sudo chown "$git_user:$git_user" "$repo_path/description"

    echo "Description updated for $repo_name"
)}
