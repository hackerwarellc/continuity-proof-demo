#!/usr/bin/env bash
# Restore the demo projects to a clean known-good state.
# Run this before recording the GIF if the running Continuity extension
# has auto-polluted either folder with extra artifacts.
#
# Usage:  bash demo-projects/peer-review/scripts/reset-demo.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEMO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

WITH="$DEMO_DIR/with-continuity"
WITHOUT="$DEMO_DIR/without-continuity"

echo "==> Resetting without-continuity/ (stripping all Continuity artifacts)"
cd "$WITHOUT"
rm -rf .continuity .github .cursorrules .gitignore AGENTS.md CLAUDE.md GEMINI.md SESSION_HANDOFF.md
echo "   clean."

echo "==> Resetting with-continuity/ (restoring canonical 7 decisions)"
cd "$WITH"
# Restore the canonical decisions.json from git.
if git ls-files --error-unmatch .continuity/decisions.json > /dev/null 2>&1; then
  git checkout -- .continuity/decisions.json
  echo "   decisions.json restored from git."
else
  echo "   WARNING: .continuity/decisions.json is not tracked in git — skipping restore."
fi

# Remove auto-generated junk that isn't tracked.
for f in \
  .continuity/DECISION_INDEX.md \
  .continuity/SESSION_NOTES.md \
  .continuity/audit-cache.json \
  .continuity/convergence.json \
  .continuity/current-session.json \
  .continuity/decisions.deleted.json \
  .continuity/decisions.json.backup \
  .continuity/delta-snapshot.json \
  .continuity/dream-state.json \
  .continuity/mcp-health.json \
  .continuity/metrics.json \
  .continuity/pending-decisions.jsonl \
  .continuity/pending-decisions.state.json \
  .continuity/unfinished-task.json \
  .continuity/working-memory.json \
  .continuity/.instructions-generated \
  SESSION_HANDOFF.md; do
  [ -e "$f" ] && rm -f "$f" && echo "   removed $f"
done
[ -d .continuity/dream-reports ] && rm -rf .continuity/dream-reports && echo "   removed .continuity/dream-reports/"

# Regenerate instruction files so they reflect only the 7 canonical decisions.
# Prefer the globally-installed CLI; fall back to the local dev CLI in this repo.
REPO_ROOT="$(cd "$DEMO_DIR/../.." && pwd)"
LOCAL_CLI="$REPO_ROOT/continuity-cli/bin/continuity.js"

if command -v continuity > /dev/null 2>&1 && continuity --help > /dev/null 2>&1; then
  echo "==> Regenerating instruction files via global continuity CLI"
  continuity generate > /dev/null
  echo "   done."
elif [ -x "$LOCAL_CLI" ] || [ -f "$LOCAL_CLI" ]; then
  echo "==> Regenerating instruction files via local dev CLI ($LOCAL_CLI)"
  node "$LOCAL_CLI" generate > /dev/null
  echo "   done."
else
  echo "   NOTE: no CLI found. Install globally (npm i -g @continuity/cli) or"
  echo "   ensure continuity-cli/bin/continuity.js exists in the repo root."
fi

echo ""
echo "✔ Demo reset complete."
echo "  with-continuity:    7 canonical decisions, instruction files regenerated."
echo "  without-continuity: stripped clean."
echo ""
echo "If the Continuity VS Code extension is enabled in either workspace,"
echo "it will re-pollute these folders on open. Disable per-workspace via"
echo "  Extensions panel → gear → Disable (Workspace)"
echo "before recording the demo."
