set_action "import~" "repo_name remote_url -m -d="                            \
"Import an existing repository by cloning it into this server (bare/mirror)"  \
"Usage:"                                                                      \
"  %program_name% %action_name% %repo_name% %remote_url% [-m] [-d=\"...\"]"   \
""                                                                            \
"Options:"                                                                    \
"  -m            Use --mirror instead of --bare (recommended for mirrors)"    \
"  -d=\"...\"      Set repository description (gitweb uses this)"             \
""                                                                            \
"Examples:"                                                                   \
"  %program_name% %action_name% my_repo https://github.com/org/proj.git"      \
"  %program_name% %action_name% my_repo git@github.com:org/proj.git -m"       \
"  %program_name% %action_name% my_repo git@github.com:org/proj.git -d=\"Imported from GitHub\"" \
""

import(){(
    [[ "$repo_name" == *.git ]] || repo_name="${repo_name}.git"

    if [[ ! "$repo_name" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $repo_name"
      return 1
    fi

    if [ ! -d "$git_repositories" ]; then
      echo "ERROR: Repositories folder does not exist: $git_repositories"
      return 1
    fi

    repo_path="$git_repositories/$repo_name"

    if [ -e "$repo_path" ]; then
        echo "ERROR: Repository already exists: $repo_name"
        return 1
    fi

    clone_mode="--bare"
    if [[ ${m:-0} -gt 0 ]]; then
        clone_mode="--mirror"
    fi

    echo "Importing $remote_url -> $repo_name ($clone_mode)" >&2

    sudo -u "$git_user" git clone "$clone_mode" "$remote_url" "$repo_path" || return 1

    # Optional description, via -d="..."
    if [[ -n "${d:-}" ]]; then
        echo "$d" | sudo tee "$repo_path/description" >/dev/null
        sudo chown "$git_user:$git_user" "$repo_path/description"
    else
        # Keep your convention: ensure description exists
        if [ ! -f "$repo_path/description" ]; then
            echo "Imported repository. Please set a description." | sudo tee "$repo_path/description" >/dev/null
            sudo chown "$git_user:$git_user" "$repo_path/description"
        fi
    fi

    sudo chown -R "$git_user:$git_user" "$repo_path"

    echo "Repository imported: $repo_name"
)}

