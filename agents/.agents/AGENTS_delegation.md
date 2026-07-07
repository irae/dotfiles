# If you are NOT my main agent:

Ignore this file, you got here by mistake.

## Picking a folder:

**Root folder**
* Best if framework folders are git-ignored and exist, e.g. docs/superpowers/ and .rpiv/
* Fallback to build/, artifacts/, etc.
* If none available, use `/tmp/[repo-name]/delegation/`

**Guidelines**
* Once root is decided, use this structure, pass full path to subagents
* You tell what each subagent needs to know, not the whole structure
* All files use meaningful slugs up to 50 chars in plaintext format
* If using agent names prefix name before dates, otherwise roles before dates

**Structure:**
* Follow your framework conventions over this structure, where it overlaps
* `agent-communications/` subfolder to send tasks and receive replies
* `handoff/` where you handoff session for compaction
* `progress/` notes, todos, etc. Create this when the framework has no equivalent folder of its own
* `outdated/` move superseded plans here verbatim (folders are git-ignored), so the user can review or pull them back later
* `drafts/` where the user drops pre-session material; merge incoming items with what is already here
* `templates/` prompt template per role (see below)
* `templates/` special treatment: if you are on a git worktree but not main worktree, resolve the main worktree and scout for gitgnored templates/ folder with prompt templates. Then symlink their `templates/` to your root folder. This way templates are shared per repo, across agent runs. As user tweaks those, the tweaks are propagated across. Start with the templates already there.

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
* Subagents must be told to read ~/.agents/AGENTS.md (pass full path)
* Level 1 and 2 communicate via files paths, you don't read the files, only pass along
* Level 2 can't request subagents
* Level 2 subagents will give you a response filepath. You relay filepath and tell the level 1 subagent to read results and proceed with their task

**Adjusted behavior based on your model**
* If you are a WEAK model, don't try to understand architecture
* If you are a WEAK model during multi-step execution of plans, ask narrow questions to the planner instead of user
* When you are WEAK and WEAK implementer disagrees with the design/architecture, halt and escalate to the user
* If you are a STRONG model, catch subagent architectural mistakes via their responses and summaries, spawn a narrow scoped reviewer to check the code if you are suspicious of mistakes from WEAK agents summaries

## Agent "watchdog" with ScheduleWakeup

Subagents can stall when spawned without oversight: an agent loops, times out, hits the 5-hour context limit, or tooling hangs. Use watchdog ScheduleWakeups to detect and recover from these conditions.

### Subagent stall prevention

For each subagent you spawn, estimate its task duration, then schedule a ScheduleWakeup for double that time. When it fires:

1. Check the agent's status (is it progressing, stuck, or done?)
2. If stuck, restart it with a fresh prompt
3. If it's running long-wait operations (deploying, migrating databases), reschedule without interrupting
4. If it will continue normally, say nothing in chat and reschedule

Use this pattern:

```javascript
ScheduleWakeup({
  delaySeconds: estimatedTaskSeconds * 2,
  prompt: "Check agent [name] for stall per AGENTS_delegation.md",
  reason: "Stall prevention",
})
```

### Plan exhaustion prevention

When the user signals concern about context limits, maintain 5 overlapping ScheduleWakeups at 1h, 2h, 3h, 4h, and 5h. Each time one fires, reschedule it 5h later. This sliding alarm window ensures early warning if the session stalls.

When a plan-exhaustion alarm fires, analyze the chat:
- If agents are working, the plan is still consuming credits — reschedule
- If you and the user are both idle, there's nothing to resume — reschedule anyway

Use this pattern:

```javascript
ScheduleWakeup({
  delaySeconds: 3600, // 1h, 2h, 3h, 4h, or 5h from now
  prompt: "Check main conversation and running agents for stalled work; resume if needed",
  reason: "Plan exhaustion checkpoint",
})
```


## Choosing subagents types, roles and names

**Rules to delegating to subagents:**
* Don't fork your context unless the user told you, send file references instead
* When I say to start an agent with a role, it means to find the best agent type and tell the subagent which skills to load for that role
* Use previously written template or write a minimal prompt template per role for reuse, so you don't write it over and over
* Prefer pointing subagents to documentation, framework and communication files. Add context missing from files
* Don't load execution skills yourself; the subagent loads them. If the harness lets you pass skills as IDs, do that; otherwise name them in the brief

**Subagent models**
* Planning and brainstorms use STRONG model. To ask follow-up questions or replan, reuse the prior session: in pi, pass `context: "fork"` or use the `resume` control action; in harnesses without session primitives, re-prompt with the prior summary. If a prior session can't be resumed, the rebrief must include the skill-loading instructions again
* Code reviewing, debugging across concerns and many files, and searching the web for documentation should use MEDIUM model
* Final review of tasks towards the end of plan execution should be done with STRONG models. Their asks for refactor should be done by STRONG implementers.
* Security work uses STRONG models
* Executing, working, developing, writing code and anything else should use WEAK model, if they fail twice, give their progress and shortcomings to a MEDIUM fresh agent
* Delegate even if your model is the same as target subagent model
