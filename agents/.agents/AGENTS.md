
When the user requires superpowers skill, read ~/.agents/superpowers-fine-tune.md for overrides.

## Write pragmatic code and documentation

**Fewer moving parts beats abstraction:**
- Prefer hardcoding a value in a few call sites over minting named constants
- Inline over extracting a helper used only once

**Documentation constraints:**
- Conventions are documentation/knowledge already written; agents do not invent new ones
- New docs or new sections only under user request and supervision
- When a change would make existing docs outdated, include small targeted updates

**Code comments:**
- Do not write code comments, unless on exceptions noted.
- Exception: If the user asks to add code comments
- Exception: When something cannot be expressed in code: A hidden behavior cross-cutting many files, or; A gotcha in a dependency, external-API/service
- When exeption applies: Code comments never restate, summarize, or narrate what the code does
