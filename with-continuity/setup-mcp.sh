#!/usr/bin/env bash
#
# setup-mcp.sh — stage the paydash-api fixture at /tmp/paydash-api/ so the
# Claude Code recording shows a clean path bar (no parent-repo leak).
#
# Why /tmp: Claude Code's header displays the cwd. If we ran from
#   demo-projects/peer-review/with-continuity/ inside the real repo, every
#   frame would show "~/DEV/continuity-ultimate/demo-projects/..." and leak
#   the real repo name. /tmp/paydash-api/ reads as a self-contained project.
#
# Idempotent. Called by every *-with-continuity.tape via absolute path
# before launching claude.
#
set -euo pipefail

FIXTURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="/tmp/paydash-api"
NODE_BIN="$(command -v node)"
STABLE_LINK="$HOME/.vscode/extensions/continuity-mcp-stable"
MCP_SERVER="$STABLE_LINK/packages/mcp-server/dist/index.js"

if [ ! -e "$MCP_SERVER" ]; then
  echo "ERROR: Continuity MCP server not found at $MCP_SERVER" >&2
  echo "       Ensure DEV VSIX is installed and stable symlink is set." >&2
  exit 1
fi

# ── Fresh copy of the fixture into /tmp ─────────────────────────────────────
# rsync would handle this in one line but isn't always installed; cp -R works.
rm -rf "$WORKSPACE"
mkdir -p "$WORKSPACE"
cp -R "$FIXTURE_DIR/." "$WORKSPACE/"
echo "  ✓ paydash-api copied to $WORKSPACE"

# ── Generate .mcp.json pointing CONTINUITY_WORKSPACE at /tmp/paydash-api ────
cat > "$WORKSPACE/.mcp.json" <<EOF
{
  "mcpServers": {
    "continuity": {
      "type": "stdio",
      "command": "$NODE_BIN",
      "args": [
        "$MCP_SERVER"
      ],
      "env": {
        "CONTINUITY_WORKSPACE": "$WORKSPACE",
        "CONTINUITY_ROUTE_STDOUT_LOGS": "1"
      }
    }
  }
}
EOF
echo "  ✓ .mcp.json written"

# ── Scrub regenerated instruction files in the COPY ─────────────────────────
# Continuity's ProjectInstructionsGenerator runs `git log` from the cwd. Even
# though /tmp/paydash-api isn't a git repo, the extension may write template
# instruction files there. Delete them so the recording uses MCP tools live.
rm -f "$WORKSPACE/CLAUDE.md" \
      "$WORKSPACE/AGENTS.md" \
      "$WORKSPACE/GEMINI.md" \
      "$WORKSPACE/.cursorrules" \
      "$WORKSPACE/.github/copilot-instructions.md" \
      "$WORKSPACE/SESSION_HANDOFF.md" \
      "$WORKSPACE/setup-mcp.sh" 2>/dev/null || true
rmdir "$WORKSPACE/.github" 2>/dev/null || true
echo "  ✓ scrubbed instruction files + setup script from copy"

echo "  → cd $WORKSPACE && claude --dangerously-skip-permissions"
