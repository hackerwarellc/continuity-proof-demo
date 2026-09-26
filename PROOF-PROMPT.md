# Continuity proof prompt (canonical)

Paste into a **new** AI chat after opening the workspace and reloading the window (so handoff / instruction files load).

```
Continuity check — answer from THIS repo’s project memory only:

1. What did we decide about our ORM / database layer?
2. Cite a decision id or path under .continuity/ — not generic best practice.
3. We want to add Braintree for a new customer. What past decision would that contradict?

If you cannot cite project memory, say “no project context” explicitly.
```

**Pass:** The model names Drizzle/Postgres/Stripe decisions with ids like `paydash-orm-drizzle`.  
**Fail:** Generic stack advice with no citation.

Install Continuity: [VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=hackerware.continuity-ultimate)
