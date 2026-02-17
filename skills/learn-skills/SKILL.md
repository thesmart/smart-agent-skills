---
name: learn-skills
description: 'Activate when the user asks to create a new Claude Code skill, write a SKILL.md, or learn how skills work. Triggers: new skill, create skill, write skill, skill template, SKILL.md. Do NOT activate when the user wants to install or run an existing skill.'
argument-hint: [skill-topic]
license: MIT
compatibility: Designed for Claude Code (and compatible)
metadata:
  author: thesmart
  version: '1.0'
---

# Skill Authoring Guide

You help users create well-structured, token-efficient Claude Code skills.

## What is a Skill?

A skill is a `SKILL.md` file with YAML frontmatter and markdown instructions. When installed to
`~/.claude/skills/`, Claude Code loads it as context when the agent determines the skill matches the
user's request. The `description` field in the frontmatter is what the agent uses to decide whether
to activate the skill.

## SKILL.md Structure

```yaml
---
name: my-skill
description: "Activate when [trigger conditions]. Triggers: [keyword list]. Do NOT activate when [exclusions]."
argument-hint: [arg-description]
license: MIT
compatibility: Designed for Claude Code (and compatible)
metadata:
  author: github-handle
  version: '1.0'
---
```

### Frontmatter Fields

| Field           | Required | Description                                                             |
| --------------- | -------- | ----------------------------------------------------------------------- |
| `name`          | yes      | Kebab-case identifier, used as install directory name                   |
| `description`   | yes      | Must include "when to activate" AND "when NOT to activate" instructions |
| `argument-hint` | no       | Hint shown to users for what argument to pass (e.g. `[diagram-type]`)   |
| `license`       | yes      | License identifier                                                      |
| `compatibility` | yes      | Target platform                                                         |
| `metadata`      | yes      | Must include `author` and `version`                                     |

### Body (After Frontmatter)

The markdown body is the skill's instructions to the agent. Structure it as:

1. **Role / overview** -- one-line summary of what the agent does with this skill
2. **Reference material** -- syntax, API specs, lookup tables the agent needs
3. **Instructions** -- numbered step-by-step procedure the agent follows
4. **Dependencies** -- runtime requirements (prefer none or widely-available tools)

## Key Principles

### Token efficiency

Every token in a skill competes with the user's problem for the agent's attention. Minimize context
to what the agent actually needs:

- **BNF grammars over prose** -- LLMs read grammars fluently and they compress syntax into far fewer
  tokens than prose descriptions or examples
- **Tables over paragraphs** -- for enumerating options, parameters, or mappings
- **No examples in context files** -- examples waste tokens and are less precise than grammars
- **Merge redundant sections** -- don't repeat yourself

### Progressive disclosure

Don't inline large reference material. Instead, put it in `./context/*.md` files and link to them.
The agent reads these only when it needs them.

```
skills/my-skill/
  SKILL.md              # Main skill (always loaded)
  context/              # Loaded on demand
    api-reference.md
    syntax-spec.md
  helper-script.sh      # Optional tooling
```

In the SKILL.md, reference context files with relative links:

```markdown
For full API details, see [API reference](./context/api-reference.md).
```

### Validation

Include a validation step whenever possible. The agent should verify its output before presenting it
to the user. Examples:

- Render a diagram with a CLI tool to catch syntax errors
- Lint generated code
- Run a generated script with `sh -n` for syntax checking
- Fetch a constructed URL to verify it returns expected content

### Description quality

The `description` field is critical -- it's how the agent decides whether to activate the skill.
Write it as activation instructions:

**Good:**

```yaml
description: 'Activate when the user asks to create, edit, or add badges to a README.
  Triggers: badge, shield, version badge. Do NOT activate for other image generation.'
```

**Bad:**

```yaml
description: 'A tool for making badges'
```

## Instructions

1. Ask the user what the skill should do and what domain it covers.
2. Determine:
   - **Name**: kebab-case, descriptive (e.g. `code-shields-io`, `diagram`)
   - **Triggers**: what user phrases should activate it
   - **Exclusions**: what should NOT activate it
   - **Context size**: will it need `./context/` files for progressive disclosure?
   - **Dependencies**: what tools does it need at runtime?
   - **Validation**: how can the agent verify its output?
3. Create `skills/<name>/SKILL.md` with proper frontmatter.
4. If the skill needs reference material, create `skills/<name>/context/` files with BNF grammars
   and concise tables. Link them from the SKILL.md.
5. If the skill needs helper scripts, create them alongside the SKILL.md.
6. Format with `deno fmt` and spell check with `typos`.

## Dependencies

None.
