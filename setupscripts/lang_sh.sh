#!/usr/bin/env bash
# =============================================================================
# lang_sh.sh — Shell language setup
# Sourced by envsetup. Requires: ok, warn, step, pkg_install, BOLD
# =============================================================================

echo ""
echo -e "  ${BOLD}Setting up Shell...${RESET}"

# --- shellcheck (linter, used by coc-sh for diagnostics) ---
if command -v shellcheck > /dev/null 2>&1; then
    ok "shellcheck already installed — skipping"
else
    step "Installing shellcheck" pkg_install shellcheck
fi

# coc-sh is listed in g:coc_global_extensions in vimrc and installs
# automatically on next Vim open. It uses shellcheck for diagnostics and
# provides LSP features (completion, go-to-definition, hover) for .sh files.
ok "coc-sh installs automatically on next Vim open"

# --- Filetype note ---
# Vim detects bash/sh filetype from the shebang line (#!/usr/bin/env bash),
# so files without a .sh extension (e.g. envsetup) get full syntax
# highlighting and LSP support as long as the shebang is present.

# --- Debugger note ---
# Bash debugging via Vimspector uses vscode-bash-debug. Run:
#   :InstallDebugger vscode-bash-debug
# from your project root. Note: the generated .vimspector.json needs extra
# fields that the generator does not add automatically. After running it,
# edit the file to add: pathBash, pathBashdb, pathCat, pathMkfifo, pathPkill.
# See the README Debugging section for the full config.
# For simple scripts, 'set -x' at the top of the file is often enough.
warn "Debugger: run :InstallDebugger vscode-bash-debug from your project root."
warn "The generated .vimspector.json needs manual edits — see README for details."
