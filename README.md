Notenwart – Git Repository Manager
==================================

**Notenwart** *(noun)*
German: *Noten* (musical scores) + *Wart* (guardian, keeper),
A person responsible for maintaining, organizing, and preserving musical scores.

Author: Manlio García [info@manliogarcia.es](mailto:info@manliogarcia.es)

Notenwart is a Git repository administration tool built on top of the
**Clavichord** framework.

Clavichord provides the execution engine, argument parsing, help system and
autocompletion.
Notenwart is an *action pack* that gives Clavichord a concrete purpose:
managing a self-hosted Git server.

This project allows system administrators to create, import, list, rename,
describe and delete Git repositories in a safe, structured and repeatable way,
without exposing the raw filesystem or requiring ad-hoc scripts.

All repositories are managed as **bare Git repositories**, suitable for use
with SSH push/pull and GitWeb.

---

## Usage

Clone the project:

```bash
# git clone --recurse-submodules <git_clone_url> /usr/local/lib/notenwart
```

Add the executable directory to your PATH:

```bash
# export PATH="$PATH:/usr/local/lib/notenwart/bin"
```

Make it permanent for your user:

```bash
# echo 'export PATH="$PATH:/usr/local/lib/notenwart/bin"' >> ~/.bashrc
```

Or system-wide:

```bash
# echo 'export PATH="$PATH:/usr/local/lib/notenwart/bin"' >> /etc/profile
```

Enable bash autocompletion:

```bash
# cd /usr/local/lib/notenwart
# ./install_autocompletion.sh
```

Open a new shell and test:

```bash
notenwart -h
```

---

## Available commands

```text
notenwart list
notenwart create <repo_name>
notenwart import <repo_name> <remote_url> [-m] [-d="description"]
notenwart describe <repo_name> "description"
notenwart rename <old_name> <new_name>
notenwart delete <repo_name> [-f]
notenwart actions [-d]
```

### list

List all bare Git repositories managed by the server.

### create

Create a new empty bare repository:

```bash
notenwart create my_project
```

Creates:

```
/srv/git/repos/my_project.git
```

and initializes the description file.

---

### import

Import an existing Git repository:

```bash
notenwart import my_project https://github.com/org/project.git
```

Options:

* `-m` → use `git clone --mirror` instead of `--bare`
* `-d="..."` → set repository description

Examples:

```bash
notenwart import my_repo git@github.com:org/proj.git -m
notenwart import my_repo git@github.com:org/proj.git -d="Imported from GitHub"
```

---

### describe

Set the repository description used by GitWeb:

```bash
notenwart describe my_project "Main backend service"
```

This writes directly to:

```
/srv/git/repos/my_project.git/description
```

---

### rename

Rename an existing repository:

```bash
notenwart rename old_name new_name
```

Note: Clients must update their Git remote URLs after this.

---

### delete

Delete a repository safely:

```bash
notenwart delete my_project
```

With force (no confirmation):

```bash
notenwart delete my_project -f
```

Multiple safety guards prevent accidental deletion outside the repository root.

---

### actions

List available actions:

```bash
notenwart actions
notenwart actions -d
```

---

## Configuration

Configuration files are read in this order:

1. `/etc/notenwart/config`
2. `/etc/notenwart.conf`
3. `~/.notenwart/config`
4. `~/.notenwart.conf`

Each file overrides the previous one.

All files are simple:

```ini
KEY=value
```

Available options:

```ini
NOTENWART_GIT_USER=git
NOTENWART_GIT_FOLDER=/srv/git
NOTENWART_GIT_REPOSITORIES=/srv/git/repos
```

Defaults:

* Git user: `git`
* Git root: `/srv/git`
* Repositories folder: `/srv/git/repos`

For safety, Notenwart refuses to run if `NOTENWART_GIT_REPOSITORIES` is `/` or empty.

---

## Directory layout

```
notenwart/
├── bin/
│   └── notenwart          → Wrapper selecting the action pack
├── lib/
│   ├── clavichord/        → Execution engine
│   └── notenwart/         → Notenwart action pack
│       ├── config.sh
│       ├── completion.bash
│       └── actions.d/
│           ├── create.sh
│           ├── delete.sh
│           ├── describe.sh
│           ├── import.sh
│           ├── list.sh
│           └── rename.sh
```

When you run:

```bash
notenwart <action>
```

what really happens is:

1. The wrapper sets `program_name=notenwart`
2. Clavichord is loaded
3. Clavichord loads:

   * `lib/notenwart/config.sh`
   * `lib/notenwart/actions.d/*.sh`
4. The selected action is executed

This means you can have many Clavichord-based tools in the same system, each one
with its own action set, simply by adding new wrappers and directories.

---

## Design goals

* Safe administration of Git repositories
* No direct filesystem manipulation
* Strong validation against path traversal
* Scriptable and reproducible operations
* Clean separation between:

  * engine (Clavichord)
  * purpose (Notenwart)

This is not a Git forge (like Gitea or GitLab).
It is a **low-level, sysadmin-friendly Git repository management tool** designed
to sit under your existing SSH and GitWeb infrastructure.

