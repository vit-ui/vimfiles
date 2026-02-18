# Vim & Go Workspace

My personal configuration for Go development on WSL/Linux.

## Repository Structure
- `.vimrc`: Main configuration (CoC, vim-go, Auto-pairs, Statusline).
- `shortcuts.txt`: Reference guide for Vim, Git, and Go commands.

## Setup Instructions

### 1. Link the Configuration
Vim looks for `.vimrc` in your home directory. Link it from this repo:
```bash
ln -sf ~/vimfiles/.vimrc ~/.vimrc

```

### 2. Install Vim-Plug (Plugin Manager)

You must install the manager first so Vim can understand the `Plug` commands in your `.vimrc`:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    [https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim](https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim)

```

### 3. Install Plugins & Go Tools

1. Open Vim and run `:PlugInstall` to download the extensions.
2. Inside Vim, run `:GoUpdateBinaries` to install Go-specific tools.
3. In your terminal, install the Delve debugger:
```bash
go install [github.com/go-delve/delve/cmd/dlv@latest](https://github.com/go-delve/delve/cmd/dlv@latest)

```

## Status Bar Reference

Located at the bottom of every window:

* **Filename**: Path to the current file.
* **`[+]`**: Indicates unsaved changes.
* **`[RO]`**: Read-only file.
* **`%`**: Vertical progress through the file.
* **`L:C`**: Current Line and Column position.

## ⌨️ Custom Mappings

* `:GoHelpMe`: Opens `shortcuts.txt` in a vertical split.
* `\d`: Jump **INTO** definition (Go files only).
* `\b`: Jump **BACK** from definition (Works everywhere).
* `\ds`: **Start** Go Debugger.
* `\bp`: **Toggle** Breakpoint.
* `\dn`: **Next** line (Step Over).
* `\dc`: **Continue** to next breakpoint.
* `\dt`: **Stop** Debugger.

## Syncing Changes

To save updates to GitHub:

```bash
cd ~/vimfiles
git add .
git commit -m "update config"
git push

```

---

### 3. Push the Fix
```bash
cd ~/vimfiles
git add README.md
git commit -m "Fix markdown line endings"
git push

```
