# Linux Dev Environment with Vim

My personal development environment for WSL/Linux. Covers Vim and Bash
configuration, language-specific tooling, and a debugging setup powered by
Vimspector.

## Repository Structure

| File            | Description                                              |
| --------------- | -------------------------------------------------------- |
| `.vimrc`        | Vim config                                               |
| `.bashrc`       | Bash config                                              |
| `shortcuts.txt` | Quick reference for all shortcuts and commands |

---

## Index

| Section | Description |
| ------- | ----------- |
| [First-Time Setup](#first-time-setup) | Everything needed to get the environment running on a new machine |
| [Language Setup](#language-setup) | Per-language install steps, tooling, and shortcuts |
| [Debugging](#debugging-vimspector--dap) | How the Vimspector debugger works and how to use it |
| [Daily Reference](#daily-reference) | Shortcuts, aliases, and UI reference for everyday use |
| [Maintenance](#maintenance) | How to push and pull config changes across machines |

---

## First-Time Setup

### Required

#### 1 — Clone the repo

```bash
git clone https://github.com/vit-ui/vimfiles.git ~/vimfiles
```

#### 2 — Upgrade Vim and install Node.js

This setup requires a recent Vim build. If your system ships an older version,
upgrade it:

```bash
sudo add-apt-repository ppa:jonathonf/vim && sudo apt update && sudo apt install vim
```

Install Node.js (the JavaScript runtime that coc.nvim runs on):

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt install -y nodejs
```

#### 3 — Link configuration files

Vim and Bash look for `.vimrc` and `.bashrc` in your home directory. Link them
from this repo so your config stays version-controlled:

```bash
ln -sf ~/vimfiles/.vimrc ~/.vimrc
ln -sf ~/vimfiles/.bashrc ~/.bashrc
source ~/.bashrc
```

> These are symbolic links — the actual files stay in this repo. Any edit to
> `~/.vimrc` is really an edit to `~/vimfiles/.vimrc`, which you can then
> commit and push. Run `source ~/.bashrc` after linking to apply bash changes
> to the current terminal session without restarting it.

#### 4 — Install vim-plug and plugins

vim-plug is the plugin manager. Install it:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Then open Vim and run:

```vim
:PlugInstall
```

> On the first open, Vim automatically creates and configures
> `~/.gitignore_global` to ignore `tags` files and `.vimspector.json` (the
> per-project debugger config file).

#### 5 — Install system tools

Universal Ctags — generates tag files for code symbol navigation, required by
the Gutentags plugin:

```bash
sudo apt install universal-ctags
```

shellcheck — static analysis tool for shell scripts, used by coc-sh for
diagnostics in `.sh` and `.bashrc` files:

```bash
sudo apt install shellcheck
```

---

### Optional

#### ripgrep

a fast file content search tool that replaces grep for code
search. Used with `rg` in the terminal:

```bash
sudo apt install ripgrep
```

#### GitHub CLI (`gh`)

command-line interface for GitHub operations (creating
pull requests, cloning repos, etc.). Not required for the environment to work.

Via webi (gets latest version):

```bash
curl -sS https://webi.sh/gh | sh
```

Via apt (auto-updates with `apt upgrade`):

```bash
sudo apt install gh
```

Authenticate after installing:

```bash
gh auth login
```

---

## Language Setup

All languages format automatically on save via CoC. No manual step is needed
when adding a new language — install its CoC extension and formatter and
formatting will work on save automatically.

<details>
<summary><b>Go</b></summary>

### Requirements

- Go binary
- Delve (the Go debugger binary — must be installed manually, see step 3)

### 1 — Install Go

Download the latest `.tar.gz` from [go.dev/dl](https://go.dev/dl/) and run:

```bash
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go_XX.X.tar.gz
```

Verify:

```bash
go version
```

The Go binary directories are already in PATH via `.bashrc`.

### 2 — Install Go tooling

Inside Vim:

```vim
:GoUpdateBinaries
```

This installs gopls (the Go language server) and other vim-go tooling using
`go install` internally.

### 3 — Install Delve

Delve is the Go debugger binary. Vimspector's `delve` adapter is a config
layer that tells Vimspector how to talk to Delve via DAP (Debug Adapter
Protocol — a standard interface between editors and debuggers) — it does not
download the binary itself. Install it manually:

```bash
go install github.com/go-delve/delve/cmd/dlv@latest
```

### 4 — Set up the debugger

Navigate to your project root and open Vim:

```bash
cd ~/my-project
vim .
```

Then run:

```vim
:InstallDebugger delve
```

When launching a debug session with `\gc`, Vimspector prompts for `${program}`.
Enter the path to your entry point, e.g. `.` or `./cmd/myapp`.

See [Debugging](#debugging-vimspector--dap) for how this works.

### Shortcuts

| Command/Shortcut | Description |
| ---------------- | ----------- |
| `\r`             | Run current file |
| `\t`             | Run tests |
| `:GoAddTags`     | Add JSON tags to struct fields |

</details>

---

<details>
<summary><b>Python</b></summary>

### Requirements

- Python 3 and pip
- pipx (tool manager for Python CLI programs)
- black (formatter)
- debugpy (downloaded automatically by `:InstallDebugger debugpy`, see step 2)

### 1 — Install Python 3 and pip

They may already be present. Check:

```bash
python3 --version
pip --version
```

If missing:

```bash
sudo apt install python3 python3-pip
```

### 2 — Install pipx and black

pipx installs Python CLI tools each in their own isolated environment, while
still exposing the binary globally on your PATH. This avoids polluting the
system Python without needing flags like `--break-system-packages`:

```bash
sudo apt install pipx
pipx ensurepath
```

Install black (the formatter called on save for Python files):

```bash
pipx install black
```

Verify:

```bash
black --version
```

### 3 — Set up the debugger

Navigate to your project root and open Vim:

```bash
cd ~/my-project
vim .
```

Then run:

```vim
:InstallDebugger debugpy
```

When launching a debug session with `\gc`, Vimspector prompts for `${program}`.
Enter the path to your entry point, e.g. `main.py` or `./src/main.py`.

Unlike Delve for Go, debugpy is a pure Python package — Vimspector downloads
it directly from GitHub into its gadgets directory. No separate binary install
is needed.

See [Debugging](#debugging-vimspector--dap) for how this works.

### Shortcuts

| Command/Shortcut | Description |
| ---------------- | ----------- |
| `\r`             | Run current file with Python 3 |

</details>

---

<details>
<summary><b>Markdown</b></summary>

### Requirements

- glow (terminal Markdown renderer)

Three CoC extensions handle Markdown automatically after `:PlugInstall`:
coc-markdownlint (lints style violations as you type and on save),
coc-prettier (formats prose on save), and coc-marksman (a Markdown language
server that enables `\d` and `\fr` on internal document links between `.md`
files).

### 1 — Install glow

glow is a terminal Markdown renderer used by the `:Preview` command.

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

### Shortcuts

| Command/Shortcut | Description |
| ---------------- | ----------- |
| `\mp`            | Open rendered preview in a terminal split |
| `:Preview`       | Same as `\mp` |

</details>

---

## Debugging (Vimspector + DAP)

### How it works

Debugging is powered by Vimspector using DAP (Debug Adapter Protocol — a
standard interface between editors and language-specific debuggers). Vimspector
acts as the DAP client: it sends commands (set breakpoint, step over, etc.) and
the language-specific debugger executes them.

There are two separate components per language:

1. **The debugger** — the actual program doing the debugging. Whether
   Vimspector downloads this or you install it manually depends on what the
   debugger is. See each language block above for details.
2. **The Vimspector gadget** — a config layer that tells Vimspector how to
   launch and communicate with that debugger. This is what `:InstallDebugger`
   installs.

### The InstallDebugger command

`:InstallDebugger` is a custom command defined in `.vimrc`. It does two things:

- Runs `:VimspectorInstall <adapter>`, which downloads the gadget into
  `~/.vim/plugged/vimspector/gadgets/`
- Creates (or merges into) a `.vimspector.json` in the current directory with
  a launch configuration for that adapter

It does **not** install the debugger binary itself in all cases — see each
language block for what is and isn't handled automatically.

> **Must be run from the project root.** Navigate there first and open Vim
> with `vim .`, then run `:InstallDebugger <adapter>`.

Using Go as the reference example, the generated `.vimspector.json` looks like:

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

Run `:Format` on `.vimspector.json` to pretty-print it after generation.

### Debug flow

When you launch a debug session with `\gc`, Vimspector prompts for `${program}`.
The entry point to enter depends on the language — see the relevant language
block in [Language Setup](#language-setup).

| Shortcut | Action                |
| -------- | --------------------- |
| `\gb`    | Toggle breakpoint     |
| `\gc`    | Launch / Continue     |
| `\gn`    | Step Over             |
| `\gi`    | Step Into             |
| `\go`    | Step Out              |
| `\gs`    | Stop session          |
| `\gr`    | Restart               |
| `\gq`    | Hard reset Vimspector |

> Default `leader` is `\`

---

## Daily Reference

### Vim

The full shortcut reference is in `shortcuts.txt`. Access it with:

```vim
:Shortcuts
```

or from the terminal:

```bash
shortcuts
```

A few non-obvious ones worth knowing up front:

| Shortcut      | What it does                                              |
| ------------- | --------------------------------------------------------- |
| `dd`          | Remapped — clears line contents but leaves the empty line |
| `dl`          | Deletes the line entirely (default `dd` behavior)         |
| `qq`          | Exits insert mode (same as `<Esc>`)                       |
| `\d` / `\b`   | Jump into definition / jump back                          |
| `\cp` / `\cn` | Jump to previous / next diagnostic (error or warning)     |

### Bash

The terminal aliases and Git shortcuts are in `shortcuts.txt`. The custom
functions worth knowing by name:

- `mkcd <dir>` — creates a directory and immediately enters it
- `up [n]` — go up N directories (e.g., `up 3` = `cd ../../..`)
- `git()` — wraps git to print `git status` after every successful command
  except `status`, `help`, and `pull`. Bypass with `command git <args>`.
- `vim()` — no arguments opens the current directory in netrw. Multiple
  arguments open in vertical splits.

### Quick Config Access

| Command     | Description                                             |
| ----------- | ------------------------------------------------------- |
| `cdv`       | Jump to `~/vimfiles`                                    |
| `evim`      | Open `.vimrc`, `.bashrc`, and `shortcuts.txt` in splits |
| `shortcuts` | Open `shortcuts.txt` in less for reading                  |
| `gcp`       | `git commit && git push` in one step                    |

### UI Reference

**Status line fields:**

| Field    | Meaning           |
| -------- | ----------------- |
| Filename | Current file path |
| `[+]`    | Unsaved changes   |
| `[RO]`   | Read-only file    |
| `%`      | File progress     |
| `L:C`    | Line and column   |

**Cursor shape** (works in WSL and common Linux terminals):

- Block — Normal mode
- Beam — Insert mode
- Underline — Replace mode

**Window navigation** — use `\h \j \k \l` to move between splits. Works inside
Vimspector panels and `:terminal` buffers as well.

---

## Maintenance

### Push local changes

Use when you edit your config locally and want to save it to the repo:

```bash
cd ~/vimfiles
git add .
git commit -m "update config"
git push
```

### Pull remote changes

Use when syncing your environment from the repo (e.g., on a new machine after
initial setup):

```bash
cd ~/vimfiles
git pull
source ~/.bashrc
```

`source ~/.bashrc` applies any bash changes to the current terminal session
without restarting it.
