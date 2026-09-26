# continuity-proof-demo

**Repo home:** [github.com/hackerwarellc/continuity-proof-demo](https://github.com/hackerwarellc/continuity-proof-demo) (Hackerware org; maintained by [@alienfader](https://github.com/alienfader)).

**15-minute proof:** same tiny API codebase **with** vs **without** Continuity — see whether your AI cites **your** architectural decisions or generic advice.

No real payments, no secrets. Fictionally “paydash-api” (Express + Postgres patterns).

## Quick start

1. Install [Continuity](https://marketplace.visualstudio.com/items?itemName=hackerware.continuity-ultimate) in VS Code or Cursor.
2. Clone this repo and open **two** folders in separate windows:
   - `with-continuity/`
   - `without-continuity/`
3. In `without-continuity/`, **Disable (Workspace)** the Continuity extension (Extensions → gear → Disable Workspace) so it stays a clean control.
4. Start a **new** AI session in each window (handoff loads at session start).
5. Paste the prompt from [PROOF-PROMPT.md](./PROOF-PROMPT.md) into both chats.
6. Compare answers side-by-side.

Optional: run the app (`npm install && npm run dev` in each folder) — not required for the proof.

## What’s inside

| Folder | Purpose |
|--------|---------|
| `with-continuity/` | Same source + `.continuity/decisions.jsonl` + generated instruction files |
| `without-continuity/` | Same source, zero memory artifacts |

Seeded decisions cover Postgres, Drizzle, JWT auth, Zod, Pino, Stripe, Fly.io, and more — enough to catch “helpful” wrong answers.

## Reset before recording

```bash
bash scripts/reset-demo.sh
```

## For teams

After the proof on your own repo: shared `.continuity/` in git, [Team pricing](https://getcontinuity.io/pricing#team) (3-seat minimum).

## License

Hackerware proprietary — [LICENSE](./LICENSE). You may clone and run this repo **only** for Continuity evaluation (see file). Continuity the product is licensed separately (Marketplace / continuity terms).
