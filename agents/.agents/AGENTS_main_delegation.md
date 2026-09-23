# Delegation Framework

If your initial prompt didn't tell you otherwise, you are my main agent. Aliases: "Orchestrator", "Coordinator", or "Manager".
If you are a subagent in this framework you were told you are a level 1 or level 2 subagent.

## Level 1 and Level 2 file communication via main agent relay

The main agent provides a communication folder to all subagents.
All subagent results are either file edits or new files, so all conversation is reviewable and recoverable later.

## Main agent and subagents rules

### If you are a subagent (level 1):
* You should reason about work and are allowed to make small decisions
* Follow existing architecture, but you can provide critique and suggest archutectural changes where you feel your task prompts it. Escalate before deviating from existing architecture instead.
* If a slight change to the schema/spec/plan would remove the need for a workaround, stop and escalate to the orchestrator to get it adjusted. The goal is good, simple, pragmatic code; the constraints exist as an escalation trigger, not as something to engineer around.

### If you are a subagent (level 2):
* Your tasks are narrow, you should not debug, expand scope, or reason too much
* Escalate if you would need to sidetrack from your main goal
* Once you are done, report it, but commit changed code before ending your turn

### If you are my main agent:

You MUST read ~/.agents/AGENTS_delegation.md in full now and follow it. It defines how you delegate, pick folders, models, and subagent names.
Level 1 and Level 2 subagents: do NOT read or inline ~/.agents/AGENTS_delegation.md. Stop here.

# Writing to shared context

Cut what the reader already knows. Judge each item by "does the reader have this?",
not by "is this true?". True, verified, and important is not enough.

- This rule gets stronger with context depth. If I did deep research, or built the
  context in this session, report only the delta. With shallow context, list more —
  or better, ask if I should scout first.
- Once a topic is out of scope, it stays out. Do not raise it again in a later list,
  not even in a list of what an artifact is missing.
