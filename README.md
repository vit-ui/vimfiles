# Vim & Go Workspace

My personal configuration for development on WSL/Linux.

---

## Repository Structure

* `.vimrc` – Vim config file
* `.bashrc` – Bash config file
* `shortcuts.txt` – Quick reference for Vim, Git, Go, and debugging commands

---

## Setup Instructions

### 0) Install System Dependencies

Some useful tools(use is in `shortcuts.txt`):

```bash
sudo apt update
sudo apt install universal-ctags ripgrep gh go 
```

* ripgrep(rp) - a fast file content search tool that replaces grep for code
* GitHub CLI(gh) - a command-line interface for GitHub operations
* Universal Ctags - tool that generates tag files for code symbol indexing, used by Gutentags

### 1) Link the Configuration

Vim and Bash look for `.vimrc` and `.bashrc` respectively in your home directory. Link them from this repo:

```bash
ln -sf ~/vimfiles/.vimrc ~/.vimrc
ln -sf ~/vimfiles/.bashrc ~/.bashrc
source ~/.bashrc
```

> These are symbolic links. Keeping the files in this repo allows you to sync your configuration across different machines with a simple `git pull` or `git push`.

### 2) Install vim-plug (Plugin Manager)

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### 3) Install Plugins

Open Vim and run:

   ```vim
   :PlugInstall
   ```

> The first time you open Vim, it will automatically create and configure a global `~/.gitignore_global` to ignore `tags` and debugger config files.

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

* Runs `:VimspectorInstall <adapter_name>`
* Creates a minimal `.vimspector.json` if missing

> It does **not** install the debugger binary itself

> **Must be run in the project root directory**

As an example, for Go development, you must install the Delve binary manually before use:

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
cd ~/my-project-dir
vim .
```

Once inside Vim, execute:

```vim
:InstallDebugger delve
```

### Minimal `.vimspector.json` Example (Go)

```json
{
  "configurations": {
    "Launch": {
      "adapter": "delve",
      "filetypes": ["go"],
      "configuration": {
        "request": "launch",
        "program": "${workspaceRoot}",
        "mode": "debug"
      }
    }
  }
}
```

### Typical Debug Flow

- `<leader>gb` : Toggle breakpoint
- `<leader>gc` : Launch / Continue
- `<leader>gn` : Step Over
- `<leader>gs` : Stop
- `<leader>gq` : Hard Reset Vimspector

> Default `leader` is `\`

---

## Specific Language Setup

Highlighting and completion are handled with CoC extensions. To add a new language, add its extension name (e.g., `coc-pyright`) to the `g:coc_global_extensions` list in your `.vimrc` to ensure it installs automatically.

**Ensure** the [Setup Instructions](#setup-instructions) have been completed before proceeding

<details>
<summary><b>Go Setup</b></summary>

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

---

## Bash 
The `.bashrc` is symlinked from this repo in [step 1](#1-link-the-configuration). After linking, run:
```bash
source ~/.bashrc
```

What is included:

* `up [n]` - Navigate up N directories.
```bash
up 2 # same as cd ../..
up 3 # same as cd ../../..
```
* `$BROWSER` - Points to Brave on Windows (WSL) and default browser on linux.
    `browser` is a alias:
    ```bash
    browser # opens brave on wls and the default browser on linux
    ```

* `$PATH` additions - Adds `~/go/bin` and `/usr/local/go/bin` so Go binaries are available globally

## UI and Navigation

### Status Line Reference

* **Filename** – Current file path
* **[+]** – Unsaved changes
* **[RO]** – Read-only file
* **%** – File progress
* **L:C** – Line and column

### Cursor Behavior

* Block cursor in Normal mode
* Beam cursor in Insert mode
* Works correctly in WSL and common Linux terminals

### Window Navigation 

Use `leader` with the navigation keys to move between windows.

This works inside:

* Vimspector console
* `:terminal`
* Any terminal buffer

### General Shortcuts

To view the basic shortcuts:

```vim
:Shortcuts
```

For more shortcuts, read the `.vimrc` file:

```bash
cat ~/.vimrc
```

> Navigation keys apply centering(vim `zz` command) automatically

> The `:Shortcuts` command points to `~/vimfiles/shortcuts.txt`. If you cloned this repo to a different location, update the path in `.vimrc` at the line `command! Shortcuts vsplit ~/vimfiles/shortcuts.txt`.

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

* Vim
* Git
* Universal Ctags
* Language-specific debugger installed (e.g., Delve)
