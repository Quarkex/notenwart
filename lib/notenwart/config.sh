git_host="$(
    get_config_value \
        "NOTENWART_GIT_HOST" \
        ""
)"

git_user="$(
    get_config_value \
        "NOTENWART_GIT_USER" \
        "git"
)"

git_folder="$(
    get_config_value \
        "NOTENWART_GIT_FOLDER" \
        "/srv/git"
)"

git_repositories="$(
    get_config_value \
        "NOTENWART_GIT_REPOSITORIES" \
        "${git_folder}/repos"
)"

git_ssh_port="$(
    get_config_value \
        "NOTENWART_GIT_SSH_PORT" \
        "22"
)"

if [[ "$git_repositories" == "/" || "$git_repositories" == "" ]]; then
    echo "FATAL: git_repositories points to an unsafe path: $git_repositories"
    exit 1
fi

action_definitions_folder="$(
    get_config_value \
        "ACTION_DEFINITIONS_FOLDER" \
        "$program_lib_dir/${program_name}/actions.d"
)"
