#!/usr/bin/env bash
# =============================================================================
# lang_markdown.sh — Markdown language setup
# Sourced by envsetup. Requires: ok, warn, step, soft_step, pkg_install, PKG, BOLD
# =============================================================================

echo ""
echo -e "  ${BOLD}Setting up Markdown...${RESET}"

# --- glow (terminal renderer, used by :Preview and \mp in Vim) ---
if command -v glow > /dev/null 2>&1; then
    ok "glow already installed — skipping"
else
    case "$PKG" in
        apt)
            step "Adding glow apt repo" bash -c "
                sudo mkdir -p /etc/apt/keyrings
                curl -fsSL https://repo.charm.sh/apt/gpg.key \
                    | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
                echo 'deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *' \
                    | sudo tee /etc/apt/sources.list.d/charm.list
                sudo apt-get update -q
            "
            step "Installing glow" sudo apt-get install -y glow
            ;;
        dnf|pacman|brew) step "Installing glow" pkg_install glow ;;
    esac
fi

# --- mdless (README viewer, used by envsetup info and setupdocs) ---
if command -v mdless > /dev/null 2>&1; then
    ok "mdless already installed — skipping"
elif command -v gem > /dev/null 2>&1; then
    soft_step "Installing mdless" gem install mdless
else
    warn "Ruby gem not found — skipping mdless. Install Ruby then: gem install mdless"
fi

# coc-markdownlint, coc-prettier, and coc-marksman are listed in
# g:coc_global_extensions in vimrc and install automatically on next Vim open.
ok "CoC extensions install automatically on next Vim open"
