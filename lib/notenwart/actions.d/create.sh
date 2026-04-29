set_action "create~" "repo_name"                                              \
"Create a new bare git repository"                                            \
"Usage:"                                                                      \
"  %program_name% %action_name% %repo_name%"                                  \
""

create(){(
    if [[ -z "$repo_name" ]]; then
      echo "ERROR: Missing repository name"
      echo "Usage: notenwart create <repo_name>"
      return 1
    fi

    [[ "$repo_name" == *.git ]] || repo_name="${repo_name}.git"

    if [[ ! "$repo_name" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $repo_name"
      return 1
    fi

    repo_path="$git_repositories/$repo_name"

    if [ -e "$repo_path" ]; then
        echo "ERROR: Repository already exists: $repo_name"
        return 1
    fi

    sudo -u "$git_user" git init --bare "$repo_path" || return 1
    echo "Unnamed repository. Please set a description." | sudo tee "$repo_path/description" >/dev/null
    sudo chown "$git_user:$git_user" "$repo_path/description"

    echo "Repository created: $repo_name"
)}

