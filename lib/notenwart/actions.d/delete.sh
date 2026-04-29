set_action "delete!?" "repo_name -f"                                          \
"Remove a git repository permanently"                                         \
"Usage:"                                                                      \
"  %program_name% %action_name% %repo_name% [-f]"                             \
""                                                                            \
"The -f (force) flag turns off confirmation."                                 \
""

delete(){(
    if [[ "$git_repositories" == "/" || "$git_repositories" == "" ]]; then
      echo "FATAL: git_repositories points to an unsafe path: $git_repositories"
      return 1
    fi

    repo_name="$1"
    [[ "$repo_name" == *.git ]] || repo_name="${repo_name}.git"

    if [[ ! "$repo_name" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $repo_name"
      return 1
    fi

    repo_path="$git_repositories/$repo_name"

    if [[ $f -gt 0 ]]; then
      confirmed_action=true
      shift
    fi

    if [[ ! $confirmed_action == true ]]; then
      while true; do
        read -p "Are you sure you want to permanently delete repository “$repo_name”? " yn
        case $yn in
          [Yy]* ) confirmed_action=true; break;;
          [Nn]* ) confirmed_action=false; break;;
          * ) echo "Please answer yes or no.";;
        esac
      done
    fi

    if [ "$confirmed_action" == true ]; then
      if [ ! -d "$repo_path" ]; then
        echo "ERROR: Repository does not exist: $repo_name"
        return 1
      fi

      sudo rm -rf "$repo_path"
      echo "Repository deleted: $repo_name"
    else
      return 0
    fi
)}

