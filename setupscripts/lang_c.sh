#!/usr/bin/env bash
# =============================================================================
# lang_c.sh — C language setup
# Sourced by envsetup. Requires: ok, warn, step, pkg_install, BOLD
# =============================================================================

echo ""
echo -e "  ${BOLD}Setting up C...${RESET}"

# --- clangd (language server — LSP features via coc-clangd) ---
if command -v clangd > /dev/null 2>&1; then
    ok "clangd already installed — skipping"
else
    step "Installing clangd" pkg_install clangd
fi

# --- clang-format (formatter, called on save by CoC) ---
if command -v clang-format > /dev/null 2>&1; then
    ok "clang-format already installed — skipping"
else
    step "Installing clang-format" pkg_install clang-format
fi

# --- gcc (compiler, used by \r to compile and run the current file) ---
if command -v gcc > /dev/null 2>&1; then
    ok "gcc already installed — skipping"
else
    step "Installing gcc" pkg_install gcc
fi

# coc-clangd is listed in g:coc_global_extensions in vimrc and installs
# automatically on next Vim open. It connects CoC to clangd for LSP features.
ok "coc-clangd installs automatically on next Vim open"

warn "Debugger setup is per-project. Run :InstallDebugger CodeLLDB from your project root."
