#!/usr/bin/env bash
# =============================================================================
# lang_sh.sh — Shell language setup
# Sourced by envsetup. Requires: ok, warn, step, pkg_install, BOLD
# =============================================================================

if [[ "${LANG_ACTION:-install}" == "uninstall" ]]; then
    echo ""
    echo -e "  ${BOLD}Removing Shell tools...${RESET}"

    if command -v shellcheck > /dev/null 2>&1; then
        step "Removing shellcheck" pkg_remove shellcheck
    else
        ok "shellcheck not installed — skipping"
    fi

    return 0
fi

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
# Filetype detection for extensionless scripts (e.g. envsetup) is handled
# by the ShebangDetect augroup in vimrc, which runs filetype detect on
# BufWinEnter, BufWritePost, and InsertLeave for any file with a shebang.

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
