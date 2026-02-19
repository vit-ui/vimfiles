# Vim & Go Workspace

My personal configuration for Go development on WSL/Linux.

---

## Repository Structure

* `.vimrc` – Vim config file
* `shortcuts.txt` – Quick reference for Vim, Git, Go, and debugging commands

---

## Setup Instructions

### 1) Link the Configuration

Vim looks for `.vimrc` in your home directory. Link it from this repo:

```bash
ln -sf ~/vimfiles/.vimrc ~/.vimrc
```

### 2) Install vim-plug (Plugin Manager)

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### 3) Install Plugins

1. Open Vim and run:

   ```
   :PlugInstall
   ```

### 4) Setup Debugger
   
   click [here](#debugging-setup-vimspector--dap) to see how to set up a debugger

---

## Go Setup

1. Install Go tooling:

   ```
   :GoUpdateBinaries
   ```
2. Install the Delve debugger (required for Go debugging):

   ```bash
   go install github.com/go-delve/delve/cmd/dlv@latest
   ```
3. Run the [Debugging Setup](#debugging-setup-vimspector--dap):

    On terminal do:
    ```bash
    vim .
    ```
    and then:
    ```
    :InstallDebugger delve
    ```

---

## Status Line Reference

* **Filename** – Current file path
* **[+]** – Unsaved changes
* **[RO]** – Read-only file
* **%** – File progress
* **L****:C** – Line and column

---

## Cursor Behavior

* Block cursor in Normal mode
* Beam cursor in Insert mode
* Works correctly in WSL and common Linux terminals

---

## Window Navigation (Works Everywhere)

Use `<leader>` with the navigation keys to move between windows.

This works inside:

* Vimspector console
* `:terminal`
* Any terminal buffer

---

## General Shortcuts

To view the basic shortcuts:

```
:Shortcuts
```

For more shortcuts read the `.vimrc` file:

```bash
cat ~/.vimrc
```

---

# Debugging Setup (Vimspector + DAP)

Debugging is powered by Vimspector using the Debug Adapter Protocol (DAP).

---

## Install Debug Adapter

Custom helper command defined in `.vimrc`:

```
:InstallDebugger <adapter_name>
```

Examples:

```
:InstallDebugger delve
:InstallDebugger debugpy
:InstallDebugger CodeLLDB
```

What this does:

* Runs `:VimspectorInstall <adapter_name>`
* Creates a minimal `.vimspector.json` if missing

It does **not** install the debugger binary itself.

**Must be run on the root dir:**

```bash
vim .
:InstallDebugger delve
```

For Go, install Delve manually:

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
```

---

## Minimal `.vimspector.json` Example (Go)

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

---

## Typical Debug Flow

The Key `\` is `<leader>`

1. Open the project root
2. Set breakpoint: `\gb`
3. Start / continue: `\gc`
4. Step over: `\gn`
5. Stop: `\gs`
6. Reset if needed: `\gq`

---

## Syncing Changes

```bash
cd ~/vimfiles
git add .
git commit -m "update config"
git push
```

---

## Requirements

* Vim
* vim-plug
* Language-specific debugger installed (e.g., Delve)

