# Smart Agent Skills

I'm starting a collection of [Claude Code Skills](https://code.claude.com/docs/en/skills) built on
context engineering principles. Every skill in this repository is designed to be **token-efficient**
-- delivering maximum capability with minimal context window usage -- so the agent can focus its
attention on _your_ problem, not on re-reading bloated documentation.

This repository also includes **meta-skills**: skills whose job is to create and maintain other
skills. For example, `contextualize-mermaid-syntax` transforms verbose upstream documentation into
compact, BNF-grounded context specifications (CSpecs) that the `diagram` skill consumes at runtime.

**Key ideas:**

- **Token-efficient context** -- compress documentation into the minimum tokens an LLM needs to
  produce correct output (BNF grammars, terse reference tables, no redundant examples).
- **Progressive disclosure** -- skills load only the context they need, when they need it.
- **Skills for maintaining skills** -- meta-skills that generate and validate the context other
  skills depend on.
- **Quality through validation** -- skills include validation steps (e.g. rendering a diagram with
  Mermaid CLI) to catch errors before the user ever sees them.
- **Installers** -- Still working this out, but I'd like to develop management tools, shared
  storage, device syncing, etc.

## Skills

End-user skill live in [skills/](skills/) and are installed into `~/.claude/skills/` via the
provided `install.sh` script.

Currently a modest list of one skill. 😅

| Skill                      | Description                                                                                                                                                                                                                        | Install                       | Example Output                                                              |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- | --------------------------------------------------------------------------- |
| [diagram](skills/diagram/) | Create diagrams, charts, and visualizations directly in Markdown using [Mermaid](https://mermaid.js.org). Supports 19 diagram types including flowcharts, sequence diagrams, ER diagrams, C4 architecture, Gantt charts, and more. | `./skills/install.sh diagram` | [PostgreSQL connection resolution flowchart](./examples/postgresql-params/) |

## Meta-Skills (Root)

Meta-skills live at the repository root. They are used to create and maintain the context that other
skills depend on.

| Meta-Skill                                                    | Description                                                                                                                                                                 | Install                                     |
| ------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------- |
| [contextualize-mermaid-syntax](contextualize-mermaid-syntax/) | Transforms upstream Mermaid syntax documentation into token-efficient CSpecs (BNF grammar + concise reference). These CSpecs are what the `diagram` skill reads at runtime. | `./contextualize-mermaid-syntax/install.sh` |

## Development Setup

### Formatting

Markdown and JSON are formatted with [Deno](https://deno.com/):

```sh
brew install deno
deno fmt
```

### Spell Checking

```sh
brew install typos-cli
brew install typos-lsp
```

### VS Code Extensions

Open the workspace in VS Code to get prompted for recommended extensions, or install them manually.
See [.vscode/extensions.json](.vscode/extensions.json) for the full list:

- `denoland.vscode-deno` -- Deno language server (formatting, linting)
- `ms-python.python` -- Python support
- `charliermarsh.ruff` -- Python linter/formatter
- `tekumara.typos-vscode` -- Spell checking

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide on how to
contribute skills, what the quality bar is, and development conventions.

## License

MIT
