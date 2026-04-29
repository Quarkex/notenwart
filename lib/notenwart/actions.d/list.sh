set_action "list:" ""                                                         \
"List all bare git repositories"                                              \
"Usage:"                                                                      \
"  %program_name% %action_name%"                                              \
""

list(){(
  [ -d "$git_repositories" ] || { echo "ERROR: Repositories folder does not exist: $git_repositories"; return 1; }
  sudo -u "$git_user" find "$git_repositories" -maxdepth 1 -type d -name '*.git' -printf '%f\n' | sort
)}

