#!/usr/bin/env bash
# =============================================================================
# lang_ruby.sh — Ruby language setup
# Sourced by envsetup. Requires: ok, warn, step, soft_step, pkg_install, BOLD
# =============================================================================

echo ""
echo -e "  ${BOLD}Setting up Ruby...${RESET}"

# --- Ruby (runtime — required by everything below) ---
if command -v ruby > /dev/null 2>&1; then
    ok "Ruby $(ruby --version | awk '{print $2}') already installed — skipping"
else
    step "Installing Ruby" pkg_install ruby-full
fi

# --- solargraph (language server — LSP features via coc-solargraph) ---
if command -v solargraph > /dev/null 2>&1; then
    ok "solargraph already installed — skipping"
else
    step "Installing solargraph" sudo gem install solargraph
fi

# --- rubocop (formatter, used by solargraph for formatting on save) ---
if command -v rubocop > /dev/null 2>&1; then
    ok "rubocop already installed — skipping"
else
    step "Installing rubocop" sudo gem install rubocop
fi

# --- debug gem (provides rdbg — the Ruby debugger binary) ---
# Ruby 3.1+ ships with debug, but it may need installing on older versions.
if command -v rdbg > /dev/null 2>&1; then
    ok "rdbg (debug gem) already installed — skipping"
else
    step "Installing debug gem" sudo gem install debug
fi

# coc-solargraph is listed in g:coc_global_extensions in vimrc and installs
# automatically on next Vim open. It connects CoC to solargraph for LSP features.
ok "coc-solargraph installs automatically on next Vim open"

warn "Debugger setup is per-project. Run :InstallDebugger vscode-rdbg from your project root."
