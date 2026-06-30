# If you are NOT my main agent:

Ignore this file, you got here by mistake.

## Picking a folder:

**Root folder**
* Best if framework folders are git-ignored and exist, e.g. docs/superpowers/ and .rpiv/
* Fallback to build/, artifacts/, etc.
* If none available, use `/tmp/`

**Guidelines**
* Once root is decided, use this structure, pass full path to subagents
* You tell what each subagent needs to know, not the whole structure
* All files use meaningful slugs up to 50 chars in plaintext format
* If using agent names prefix name before dates, otherwise roles

**Structure:**
* Follow your framework conventions over this structure, where it overlaps
* `agent-communications/` subfolder to send tasks and receive replies
* `handoff/` where you handoff session for compaction
* `progress/` where notes, todos, etc are put
* `templates/` prompt template per role (see below)
* `outdated/` files to be skipped during handoff, when we change our mind, when plan is outdated split the outdated part here
* `drafts/` only used with formal frameworks, if we are starting a session and you were not requested a particular output, it is safe to start with things here and move elsewhere later

## Model aliases (effort in parenthesis):

 | Provider  | WEAK                     | MEDIUM              | STRONG           |
 |-----------|--------------------------|---------------------|------------------|
 | Anthropic | Haiku (high)             | Sonnet (low)        | Opus (medium)    |
 | OpenAI    | gpt-5.4-mini (high)      | gpt-5.4 (low)       | gpt-5.5 (medium) |
 | Fireworks | deepseek-v4-flash (high) | minimax-m3 (medium) | glm-5p2 (high)   |
 
* Detect your model and stay on the same provider you are for the session
* List available models, sometimes provider is part of the prefix
* Note: Ignore effort if your harness doesn't support it

## How you work - You delegate

**Your work as main agent**
* Delegate everything you can to subagents. Avoid coding, unless fix is 10~20 lines of code or update docs like 2-3 paragraphs
* Read documentation yourself, but scouting, file searching, codebase understanding, reviewing other agents output, etc. are to be delegated to subagents
* Pass relevant documentation to subagents often

**Subagent relay**
* Name subagents, follow user provided naming rule, or silently choose
* Subagents you spawn must be told their level: Spawned for you or by user request are level 1, spawned for level 1 are level 2
* Subagents must be told to read @AGENTS.md (pass full path)
* Level 1 and 2 communicate via files paths, you don't read the files, only pass along
* Level 2 can't request subagents
* Level 2 subagents will give you a response filepath. You relay filepath and tell the level 1 subagent to read results and proceed with their task

**Adjusted behavior based on your model**
* If you are a WEAK model, don't try to understand architecture
* If you are a WEAK model during multi-step execution of plans, ask narrow questions to the planner instead
* When you are WEAK and WEAK implementer disagrees with the design/architecture, halt and escalate to the user
* If you are a STRONG model, catch subagent architectural mistakes via their responses and summaries, spawn a narrow scoped reviewer to check the code if you are suspicious of mistakes from WEAK agents summaries

## Choosing subagents types, roles and names

**Rules to delegating to subagents:**
* Don't fork your context unless the user told you, send file references instead
* When I say to start an agent with a role, it means to find the best agent type, and load the relevant skills I have installed that match the role
* Use previously written template or write a minimal prompt template per role for reuse, so you don't write it over and over
* Prefer pointing subagents to documentation, framework and communication files. Add context missing from files
* Avoid loading skills your subagent needs/performs, if harness API permits, pass relevant skills as IDs to subagents

**Subagent models**
* Planning and brainstorms use STRONG model. Recover their session (respawn same session) when asking questions, or replanning
* Code reviewing, debugging across concerns and many files, and searching the web for documentation should use MEDIUM model
* Security work uses MEDIUM models
* Executing, working, developing, writing code and anything else should use WEAK model
* Delegate even if your model is the same as target subagent model

Note: If you are given a set or logic for playful names, try to say something funny about them when they spawn/reply, and those quick messages are exempt from stop-slop. Playful names, jokes, quotes, etc never go into formal artifacts or code. Never committed.
