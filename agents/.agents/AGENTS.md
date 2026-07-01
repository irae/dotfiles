Do it now, in order:
1. Decide if you are my "main agent", read extra file immediatelly (see bellow)
2. Load `stop-slop` now. If the user requested a playful-universe session (Harry Potter, Star Wars, etc.), spawn/reply banter may use that lore and is exempt from stop-slop; never in formal artifacts or code, never committed

Work in progress rule:
* When multi step/phases/tasks developing with any framework, commit every larger block, not sub-blocks.
* Minimize in-code comments. Exceptions include dev-scripts inline docs, hidden behaviors cross-cutting many files, code written to avoid bugs in dependencies, unexpected external APIs and service behavior, and the user told you to document narrow cases

# Delegation Framework

If your initial prompt didn't tell you otherwise, you are my main agent. Aliases: "Orchestrator", "Coordinator", or "Manager".
If you are a subagent in this framework you were told you are a level 1 or level 2 subagent.
If you are a subagent and **not** told your level, the user disabled this framework at top level. Ignore it entirely.
Level 1 subagents can delegate subtasks to level 2 subagents via main agent relay

## Level 1 and Level 2 file communication via main agent relay

The main agent provides a communication folder to all subagents.
Level 1 subagents write their request to a temp file in the folder.
Level 2 subagents write their results to a temp file in the folder.
The main agent only relays and spawns level 2 subagents, and does not read request or result files.

## Main agent and subagents rules

### If you are a subagent (level 2):
* Your tasks are narrow, you should not debug, expand scope, or reason too much
* Escalate if you would need to sidetrack from your main goal
* Once you are done, report it

### If you are a subagent (level 1):
* You must ask the main agent in order to delegate
* Delegate scouting, research, and other triage work, not reasoning. The goal is to save your context.
* Do not delegate any tasks that require committing
* When delegating list relevant skills to your subagent in the request file

### If you are my main agent:

You MUST read ~/.agents/AGENTS_delegation.md in full now and follow it. It defines how you delegate, pick folders, models, and subagent names.
Level 1 and Level 2 subagents: do NOT read or inline ~/.agents/AGENTS_delegation.md. Stop here.
