# Contributing

Thanks for your interest in contributing to Smart Agent Skills! This guide covers what makes a good
skill, where to put your code, and how to keep quality high.

## What Makes a Good Skill

### Token-efficient context

The single most important quality of a skill is **token efficiency**. Every token in a skill's
context competes with the user's actual problem for the model's attention. Write the minimum context
the agent needs to produce correct output.

Here are some tips that work well:

- **Use progressive disclosure** to load only the context agents need, when they need it.
  - reference file paths instead of inlining context or code snippets
- **Use BNF grammars** to define syntax instead of prose descriptions. LLMs are insanely good at
  writing them and reading them, and they are very token-efficient.
- **Avoid examples in context files** -- examples are better than nothing, but they can be
  non-token-efficient and are not precise.
- **No redundant sections** -- merge related concepts; don't repeat yourself.

### Skills for maintaining skills

If your skill depends on upstream documentation that changes over time (API docs, syntax specs,
etc.), consider writing a **meta-skill** that transforms that documentation into token-efficient
context. This keeps the context fresh and the transformation reproducible. See examples in the
repos.

### Transparent dependencies

Skills should be upfront about what they need. List runtime dependencies in the `SKILL.md` under a
`## Dependencies` section. Prefer **few dependencies** and widely-available ones (e.g. `npx` for
one-off CLI tools over globally installed packages).

> TODO: Dependencies should probably be linked to via a `DEPENDENCIES.md` file?

### Validation

Include a validation step in your skill's instructions whenever possible. For example, the `diagram`
skill renders every diagram with Mermaid CLI to catch syntax errors before the user sees them. If
your skill uses scripts, please automate tests and include code coverage analysis.

## Repository Structure

This is a **monorepo**. Each skill or meta-skill is a self-contained directory.

```
smart-agent-skills/
  skills/                          # Installable skills
    install.sh                     # Shared install script
    <skill-name>/
      SKILL.md                     # Skill definition (YAML frontmatter + instructions)
      context/                     # Token-efficient context files (optional)
  contextualize-*/                 # Meta-skills (root level)
    SKILL.md
    install.sh
    syntax/                        # Upstream source docs
    context/                       # Generated token-efficient CSpecs
    examples/                      # Validation examples
  examples/                        # Example outputs from skills
    <example-name>/
      README.md                    # The output artifact
      prompt.md                    # The prompt and execution log that produced it
```

### Where to put your skill

- **End-user skills** go in `skills/<skill-name>/`.
- **Meta-skills** (skills that generate context for other skills) go at the repository root as
  `contextualize-<topic>/` or a similar descriptive prefix that classifies what it does.
- **Example outputs** go in `examples/<skill-name>/` with a `README.md` (the artifact) and
  `prompt.md` (the prompt that produced it). Include as many examples as you want.

## Language and Runtime Conventions

When a skill includes code beyond shell scripts and markdown:

| Language   | Version | Runtime                   | Package Manager                  |
| ---------- | ------- | ------------------------- | -------------------------------- |
| Python     | 3.14+   | CPython                   | [uv](https://docs.astral.sh/uv/) |
| TypeScript | 5.9+    | Node.js v25+ or Deno 2.6+ | npm or Deno built-in             |
| Go         | 1.25+   | go toolchain              | go modules                       |

Really just trying to stay in LTS range.

**Notes:**

- **Python** projects must use `uv` for dependency management.
- **TypeScript** projects either define `package.json` or `deno.json`.
- **Go** is fine for tooling, but skills **should not ship pre-built binaries** -- users will build
  from source.
- **Shell scripts** should be POSIX-compatible `sh` or `bash` and work on macOS and Linux.

## Development Dependencies

Before contributing, install the development tooling:

```sh
# Formatting (markdown, JSON)
brew install deno

# Spell checking
brew install typos-cli
brew install typos-lsp
```

### VS Code

Open the workspace to get prompted for recommended extensions, or see
[.vscode/extensions.json](.vscode/extensions.json):

- `denoland.vscode-deno` -- Deno language server (formatting)
- `ms-python.python` -- Python support
- `charliermarsh.ruff` -- Python linter/formatter
- `tekumara.typos-vscode` -- Spell checking

### Formatting

Run `deno fmt` before submitting. The repo's [deno.jsonc](deno.jsonc) configures consistent
formatting for markdown and JSON files.

## Writing a SKILL.md

Every skill needs a `SKILL.md` with YAML frontmatter:

```yaml
---
name: my-skill
description: "Detailed description that must include "when to use" and "when not to use" instructions for the agent."
argument-hint: [optional-arg-hint]
license: MIT
compatibility: Designed for Claude Code (and compatible)
metadata:
  author: your-github-handle
  version: '1.0'
---
```

Below the frontmatter, write the skill's instructions. Include scripts and the installer in the
skills package.

## Submitting a Contribution

1. Fork the repository and create a feature branch.
2. Add your skill.
3. Run `deno fmt` or `ruff` or `go fmt` etc and `typos`.
4. Include at least one example output in `examples/`
5. Open a pull request with a clear description of what the skill does and why it's useful.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
