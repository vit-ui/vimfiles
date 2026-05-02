#!/usr/bin/env bash
# =============================================================================
# lang_go.sh — Go language setup
# Sourced by envsetup. Requires: ok, warn, step, PKG, VIMFILES, BOLD, RESET
# =============================================================================

echo ""
echo -e "  ${BOLD}Setting up Go...${RESET}"

# --- Go binary ---
if command -v go > /dev/null 2>&1; then
    ok "Go $(go version | awk '{print $3}') already installed — skipping"
else
    local go_ver arch os tarball
    go_ver=$(curl -s "https://go.dev/dl/?mode=json" \
        | grep -o '"version":"go[^"]*"' | head -1 | cut -d'"' -f4)
    arch=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    tarball="${go_ver}.${os}-${arch}.tar.gz"

    step "Downloading Go ${go_ver}" curl -Lo "/tmp/${tarball}" "https://go.dev/dl/${tarball}"
    step "Installing Go to /usr/local" bash -c "
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf /tmp/${tarball}
        rm /tmp/${tarball}
    "
    export PATH=$PATH:/usr/local/go/bin
fi

# --- Delve (Go debugger binary) ---
# VimspectorInstall sets up the DAP config layer but does NOT install dlv itself.
if command -v dlv > /dev/null 2>&1; then
    ok "Delve already installed — skipping"
else
    step "Installing Delve" go install github.com/go-delve/delve/cmd/dlv@latest
fi

# --- Go tooling (gopls, vim-go binaries) ---
if [[ -f "$HOME/go/bin/gopls" ]]; then
    ok "Go tooling already installed — skipping GoUpdateBinaries"
else
    warn "Installing Go tooling — this may take a few minutes..."
    local timeout_cmd=""
    command -v timeout  > /dev/null 2>&1 && timeout_cmd="timeout 300"
    command -v gtimeout > /dev/null 2>&1 && timeout_cmd="gtimeout 300"
    step "Installing Go tooling" $timeout_cmd vim -es -u "$VIMFILES/vimrc" +GoUpdateBinaries +qall
fi

warn "Debugger setup is per-project. Run :InstallDebugger delve in your project root."
