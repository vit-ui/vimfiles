g!-- markdownlint-disable-file -->
<!-- markdownlint-disable-file -->
# Vim & Go Workspace

My personal configuration for development on WSL/Linux.

---

## Repository Structure

- `.vimrc` – Vim config file
- `.bashrc` – Bash config file
- `shortcuts.txt` – Quick reference for Vim, Git, Go, and debugging commands

---

## Setup Instructions

### 0) Install System Dependencies

**Universal Ctags** — generates tag files for code symbol navigation, required
by Gutentags:

```bash
sudo apt install universal-ctags
```

Some useful tools(use is in `shortcuts.txt`):

- ripgrep(rg) - a fast file content search tool that replaces grep for code

```bash
sudo apt install ripgrep
```

- GitHub CLI(gh) - a command-line interface for GitHub operations

Use `webi` to get the latest version:

```bash
curl -sS https://webi.sh/gh | sh
```

Via apt (auto-updates with `apt upgrade`):

```bash
sudo apt install gh
```

For instructions on language instalations go to
[Specific Language Setup](#specific-language-setup) section.

### 1) Vim version and Node.js

The default Vim shipped by Ubuntu 22.04 is too old for coc.nvim and vim-go.
Upgrade it and install Node.js before running `:PlugInstall`:

```bash
sudo add-apt-repository ppa:jonathonf/vim && sudo apt update && sudo apt install vim
```

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs
```

### 2) Link the Configuration

Vim and Bash look for `.vimrc` and `.bashrc` respectively in your home
directory. Link them from this repo:

```bash
ln -sf ~/vimfiles/.vimrc ~/.vimrc
ln -sf ~/vimfiles/.bashrc ~/.bashrc
source ~/.bashrc
```

> These are symbolic links. Keeping the files in this repo allows you to sync
> your configuration across different machines with a simple `git pull` or
> `git push`.

### 3) Install vim-plug (Plugin Manager)

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### 4) Install Plugins

Open Vim and run:

```vim
:PlugInstall
```

> The first time you open Vim, it will automatically create and configure a
> global `~/.gitignore_global` to ignore `tags` and debugger config files.

---

## Debugging Setup (Vimspector + DAP)

Debugging is powered by Vimspector using the Debug Adapter Protocol (DAP).

---

### Install Debug Adapter

To set up a debugger you run a custom helper command defined in `.vimrc`:

```vim
:InstallDebugger <adapter_name>
```

Examples:

```vim
:InstallDebugger delve
:InstallDebugger debugpy
:InstallDebugger CodeLLDB
```

What this does:

- Runs `:VimspectorInstall <adapter_name>`
- Creates `.vimspector.json` if missing, or merges into it if it already exists
- Automatically assigns filetypes for known adapters (see table below)
- For unknown adapters, prompts you to enter filetypes manually

Run `:Format` on `.vimspector.json` to pretty-print the generated file

> It does **not** install the debugger binary itself

<!-- -->

> **Must be run in the project root directory**

<!-- -->

> When you launch a debug session with `\gc`, Vimspector will prompt you to fill
> in `${program}`. Enter the path to your entry point:
>
> - Go: `.` or `./cmd/myapp`
> - Python: `main.py` or `./src/main.py`
> - C/C++: `./myapp` or `./build/myapp`

#### Example

As an example, for Go development, you must install the Delve binary manually
before use:

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
cd ~/my-project-dir
vim .
```

Once inside Vim, execute:

```vim
:InstallDebugger delve
```

Generated `.vimspector.json`:

```json
{
  "configurations": {
    "delve": {
      "adapter": "delve",
      "filetypes": ["go"],
      "configuration": {
        "request": "launch",
        "program": "${program}",
        "args": [],
        "cwd": "${workspaceRoot}",
        "env": {},
        "mode": "debug"
      }
    }
  }
}
```

#### Known Adapters

| Adapter    | Filetypes  | Language |
| ---------- | ---------- | -------- |
| `delve`    | `go`       | Go       |
| `debugpy`  | `python`   | Python   |
| `CodeLLDB` | `c`, `cpp` | C / C++  |

> you can add more in the `filetypes` variable on function `InstallDebugger`
> that is in `vimrc`

### Typical Debug Flow

- `<leader>gb` : Toggle breakpoint
- `<leader>gc` : Launch / Continue
- `<leader>gn` : Step Over
- `<leader>gs` : Stop
- `<leader>gq` : Hard Reset Vimspector

> Default `leader` is `\`

---

## Specific Language Setup

Highlighting and completion are handled with CoC extensions. To add a new
language, add its extension name (e.g., `coc-pyright`) to the
`g:coc_global_extensions` list in your `.vimrc` to ensure it installs
automatically.

**Ensure** the [Setup Instructions](#setup-instructions) have been completed
before proceeding

<details>
<summary><b>Go Setup</b></summary>

0. To install go: [Download](https://go.dev/dl/) the latest `.tar.gz` from and
   run:

    ```bash
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go_XX.X.tar.gz
    ```

    It is already in the PATH environment variable. So just verify the
    instalation with:

    ```bash
    go version
    ```

1. To install Go tooling, run this in Vim:

    ```vim
    :GoUpdateBinaries
    ```

2. Install the Delve debugger (required for Go debugging):

    ```bash
    go install github.com/go-delve/delve/cmd/dlv@latest
    ```

3. Run the [Debugging Setup](#debugging-setup-vimspector--dap):

    In the terminal, run:

    ```bash
    vim .
    ```

    and then:

    ```vim
    :InstallDebugger delve
    ```

</details>

<details>
<summary><b>Markdown Setup</b></summary>

You must install [glow](https://github.com/charmbracelet/glow "glow repo"): it
is a terminal markdown renderer. It displays formmated markdown in the terminal.

Via apt (auto-updates with `apt upgrade`):

```bash
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update && sudo apt install glow
```

Via webi (does not auto-update, re-run to update):

```bash
    curl -sS https://webi.sh/glow | sh
```

Open any `.md` file and press `\mp` or `:Preview` to open a rendered preview in
a terminal split inside Vim.

`:Format` fixes markdownlint warnings automatically (trailing spaces, missing
blank lines around headings, etc.)

</details>

---

## Bash

The `.bashrc` is symlinked from this repo. After linking, run:

```bash
source ~/.bashrc
```

What is included:

- `up [n]` - Navigate up N directories.

```bash
up 2 # same as cd ../..
up 3 # same as cd ../../..
```

- `$BROWSER` - Points to Brave on Windows (WSL) and default browser on linux.

- `$PATH` additions - Adds `~/go/bin` and `/usr/local/go/bin` so Go binaries are
  available globally

- `mkcd <dir>` - Creates a directory and immediately enters it.

```bash
    mkcd my-project  # same as mkdir -p my-project && cd my-project
```

- `$EDITOR` - Set to `vim`. Used by tools that open an editor (e.g.
  `Ctrl+X Ctrl+E` in the terminal, `git commit` without `-m`).

- `$HISTTIMEFORMAT` - Adds timestamps to shell history output. Run `history` to
  see them.

- `git()` - wraps git to automatically print `git status` after every successful
  command except `status` and `help`. To bypass: `command git <args>`.

- `vim()` - no arguments opens the current directory in netrw. Multiple file
  arguments open in vertical splits.

```bash
    vim            # opens current directory in netrw
    vim a.go b.go  # opens both files in vertical splits
```

### Aliases:

    | Alias     | Expands to                             | Description                                         |
    | --------- | -------------------------------------- | --------------------------------------------------- |
    | `..`      | `cd ..`                                | Go up one directory                                 |
    | `browser` | `$BROWSER`                             | opens brave on wsl and the default browser on linux |
    | `gs`      | `git status`                           |                                                     |
    | `gl`      | `git log --oneline --graph --decorate` | Compact visual git log                              |
    | `watch`   | `watch -n 2`                           | Repeat a command every 2 seconds by default         |

### Quick Config Access

| Command     | Description                                            |
| ----------- | ------------------------------------------------------ |
| `cdv`       | Jump to `~/vimfiles`                                   |
| `evim`      | Open `.vimrc`, `.bashrc` and `shortcuts.txt` in splits |
| `shortcuts` | Print `shortcuts.txt` to the terminal                  |
| `gcp`       | Commit and push in one step                            |

---

## UI and Navigation

### Status Line Reference

- **Filename** – Current file path
- **[+]** – Unsaved changes
- **[RO]** – Read-only file
- **%** – File progress
- **L:C** – Line and column

### Cursor Behavior

- Block cursor in Normal mode
- Beam cursor in Insert mode
- Works correctly in WSL and common Linux terminals

### Window Navigation

Use `leader` with the navigation keys to move between windows.

This works inside:

- Vimspector console
- `:terminal`
- Any terminal buffer

### General Shortcuts

To view the basic shortcuts:

In vim:

```vim
:Shortcuts
```

or in the terminal:

```bash
shortcuts # alias to cat ~/vimfiles/shortcuts.txt
```

> Navigation keys apply centering(vim `zz` command) automatically

<!-- -->

> The `shortcuts` commands point to `~/vimfiles/shortcuts.txt`. If you cloned
> this repo to a different location, update the path in `.vimrc` at the line
> `command! Shortcuts vsplit ~/vimfiles/shortcuts.txt`.

---

## Syncing Changes

### Push Local Updates

Use this when you modify your config locally and want to save it to your repo:

```bash
cd ~/vimfiles
git add .
git commit -m "update config"
git push
```

### Pull Remote Updates

Use this when you want to sync your environment with your repo:

```bash
cd ~/vimfiles
git pull
source ~/.bashrc  # Apply any changes to the current terminal
```

---

## Requirements

- Vim
- Git
- Go
- Universal Ctags
- ripgrep
- GitHub CLI (`gh`)
- Language-specific debugger binary (e.g., Delve for Go)
