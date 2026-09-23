
# Plan

You must NEVER start built-in Plan subagent type on Claude Code or any other harnesses. Any file system read-only agent is BANNED. All agents should be able to write files. Pick general-purpose if in doubt.

# Coding

Work in progress rule:
* When working with multi step/phases/tasks/sections/parts plans on any framework don't mention it in code comments, commit message, etc. We don't store history of the flow. Commiting each step is allowed, but commit message, code and comments state feature goals or bug simptom, not the step/pahse/task/section/part or the solution/implementation.
* Do not write code comments by default. Only add one when it states something the code cannot — a non-obvious *why*, a hidden behavior cross-cutting many files, or a dependency/external-API/service gotcha. Never restate, summarize, or narrate what the code does. When in doubt, omit it. Exception: the user explicitly asks you to document something (e.g. dev-script inline docs).
* Never write unit tests unless directly prompted by the user. But do update existing ones when updating code it tests.

## Write pragmatic code and documentation

**Fewer moving parts beats abstraction:**
- Prefer hardcoding a value in a few call sites over minting named constants
- Inline over extracting a helper used only once
- Code conventions stay in docs/specs, not their own module/file
- Shared libraries and services may export many methods; feature code export one function/methodclass per file, and is only extracted into its own file when a real second caller needs it

**Documentation constraints:**
- Conventions are documentation/knowledge already written; agents do not invent new ones
- New docs or new sections only under user request and supervision
- When a change would make existing docs outdated, include small targeted updates
- Do not write code comments. Two rare exceptions: 1. If the user asks to add code comments; 2. Something the code cannot be express at all: A hidden behavior cross-cutting many files, or a dependency/external-API/service gotcha. When adding code comments, never restate, summarize, or narrate what the code does.

@~/.agents/superpowers-fine-tune.md

@~/.agents/AGENTS_main_delegation.md

@~/.agents/english-ste.md
