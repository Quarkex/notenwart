set_action "origin" "repo_name"                                               \
"Print the canonical SSH remote URL for a repository"                         \
"Usage:"                                                                      \
"  %program_name% %action_name% %repo_name%"                                  \
""                                                                            \
"Resolution order for host:"                                                  \
"  1) NOTENWART_GIT_HOST if defined."                                         \
"  2) Public IP via DNS + reverse PTR lookup."                                \
"  3) hostname -f, then hostname."                                            \
""

origin(){(
    if [[ -z "${repo_name:-}" ]]; then
      echo "ERROR: Missing repository name"
      return 1
    fi

    [[ "$repo_name" == *.git ]] || repo_name="${repo_name}.git"

    if [[ ! "$repo_name" =~ ^[A-Za-z0-9._-]+(\.git)?$ ]]; then
      echo "ERROR: Invalid repository name: $repo_name"
      return 1
    fi

    # Clean trailing dot helper
    _clean_fqdn(){(
      echo "$1" | sed -e 's/[[:space:]]*$//' -e 's/\.$//'
    )}

    if [[ -z "$git_host" ]]; then
      public_ip="$(
        dig +short myip.opendns.com @resolver1.opendns.com 2>/dev/null | head -n 1
      )"

      if [[ -z "$public_ip" ]]; then
        public_ip="$(
          dig +short txt o-o.myaddr.l.google.com @ns1.google.com 2>/dev/null \
          | head -n 1 \
          | tr -d '"'
        )"
      fi

      if [[ -n "$public_ip" ]]; then
        ptr="$(
          dig +short -x "$public_ip" 2>/dev/null | head -n 1
        )"
        git_host="$(_clean_fqdn "$ptr")"
      fi
    fi

    if [[ -z "$git_host" ]]; then
      git_host="$(_clean_fqdn "$(hostname -f 2>/dev/null || true)")"
    fi
    if [[ -z "$git_host" ]]; then
      git_host="$(_clean_fqdn "$(hostname 2>/dev/null || true)")"
    fi

    if [[ -z "$git_host" ]]; then
      echo "ERROR: Could not determine host for origin URL"
      return 1
    fi

    [[ ! "$git_ssh_port" == "22" ]] && git_ssh_port=":${git_ssh_port}" || git_ssh_port=""

    # Canonical SSH URL
    echo "ssh://${git_user}@${git_host}${git_ssh_port}${git_repositories}/${repo_name}"
)}
