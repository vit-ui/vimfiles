#!/usr/bin/env bash
# =============================================================================
# lang_cpp.sh — C++ language setup
# Sourced by envsetup. Requires: ok, warn, step, pkg_install, BOLD
# =============================================================================

if [[ "${LANG_ACTION:-install}" == "uninstall" ]]; then
    echo ""
    echo -e "  ${BOLD}Removing C++ tools...${RESET}"

    # clangd and clang-format are shared with C — use soft_step since
    # they may already be removed if C was also uninstalled.
    if command -v clangd > /dev/null 2>&1; then
        soft_step "Removing clangd" pkg_remove clangd
    else
        ok "clangd not installed — skipping"
    fi

    if command -v clang-format > /dev/null 2>&1; then
        soft_step "Removing clang-format" pkg_remove clang-format
    else
        ok "clang-format not installed — skipping"
    fi

    if command -v g++ > /dev/null 2>&1; then
        step "Removing g++" pkg_remove g++
    else
        ok "g++ not installed — skipping"
    fi

    return 0
fi

# =============================================================================

echo ""
echo -e "  ${BOLD}Setting up C++...${RESET}"

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

# --- g++ (compiler, used by \r to compile and run the current file) ---
if command -v g++ > /dev/null 2>&1; then
    ok "g++ already installed — skipping"
else
    step "Installing g++" pkg_install g++
fi

# coc-clangd is listed in g:coc_global_extensions in vimrc and installs
# automatically on next Vim open. It connects CoC to clangd for LSP features.
# clangd handles both C and C++ — no separate server needed.
ok "coc-clangd installs automatically on next Vim open"

warn "Debugger setup is per-project. Run :InstallDebugger CodeLLDB from your project root."
