# Smart Agent Skills

This is a **skill authoring** repository. You are here to create, edit, and maintain Claude Code
skills -- not to run or install them.

## Repository Layout

```
skills/<name>/SKILL.md        End-user skills (installed into ~/.claude/skills/)
contextualize-*/SKILL.md      Meta-skills that generate context for other skills
examples/<name>/               Example outputs from skills
```

Each skill or meta-skill is self-contained in its own directory with a `SKILL.md` definition.

## Progressive Disclosure -- Read Only What You Need

**Do NOT eagerly read files in subdirectories.** This repository contains many context files,
syntax specs, and examples that are expensive to load. Follow this protocol:

1. Start here. This file tells you the project structure and conventions.
2. Read [CONTRIBUTING.md](CONTRIBUTING.md) only when creating a new skill or making structural
   changes.
3. Read a specific `SKILL.md` only when the user asks you to work on that skill.
4. Read files in `context/`, `syntax/`, or `examples/` subdirectories only when the task requires
   their content -- never speculatively.

## Skill Anatomy

Every skill has a `SKILL.md` with YAML frontmatter (`name`, `description`, `argument-hint`,
`license`, `metadata`) followed by markdown instructions. See [CONTRIBUTING.md](CONTRIBUTING.md)
for the full spec.

## Formatting and Quality

- **Markdown/JSON**: `deno fmt` (config in [deno.jsonc](deno.jsonc))
- **Spell check**: `typos`
- **Line width**: 100 characters for prose (markdown, comments)
- **Indent**: 2 spaces for sh, ts, json, html, css; 4 spaces for py

## Key Principles

- **Token efficiency** -- compress context to the minimum tokens an LLM needs for correct output.
  Use BNF grammars over prose. Avoid inlining examples in context files.
- **Progressive disclosure** -- skills load only the context they need, when they need it. Reference
  file paths instead of inlining content.
- **Validation** -- skills should include a validation step (e.g. rendering, linting) to catch
  errors before the user sees them.