#!/usr/bin/env bash
# =============================================================================
# lang_python.sh — Python language setup
# Sourced by envsetup. Requires: ok, warn, step, pkg_install, BOLD
# =============================================================================

echo ""
echo -e "  ${BOLD}Setting up Python...${RESET}"

# --- Python 3 ---
if command -v python3 > /dev/null 2>&1; then
    ok "Python $(python3 --version | awk '{print $2}') already installed — skipping"
else
    step "Installing Python 3" pkg_install python3
fi

# --- pip ---
if command -v pip3 > /dev/null 2>&1; then
    ok "pip already installed — skipping"
else
    step "Installing pip" pkg_install python3-pip
fi

# --- pipx ---
# Installs Python CLI tools in isolated environments without polluting system Python.
if command -v pipx > /dev/null 2>&1; then
    ok "pipx already installed — skipping"
else
    step "Installing pipx"          pkg_install pipx
    step "Running pipx ensurepath"  pipx ensurepath
fi

# --- black (formatter, called on save by CoC) ---
if command -v black > /dev/null 2>&1; then
    ok "black already installed — skipping"
else
    step "Installing black" pipx install black
fi

warn "Debugger setup is per-project. Run :InstallDebugger debugpy in your project root."
warn "debugpy is downloaded automatically by :InstallDebugger — no separate install needed."
