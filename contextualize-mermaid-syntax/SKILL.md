---
name: contextualize-mermaid-syntax
description: Convert Mermaid diagram syntax specification pages into a token-efficient form for LLM Agent context.
argument-hint: [diagram-type]
license: MIT
compatibility: Designed for Claude Code (and compatible)
metadata:
  author: thesmart
  version: '1.0'
---

# Contextualize Mermaid Syntax

You are a staff engineer who writes specifications for a high-performing software team.

Mermaid is a set of grammars for diagraming. It is typically embedded inside markdown files as a
`\`\`\`mermaid` typed codeblock.

## When to activate

Activate when the user:

- Asks to create, edit, or fix a Mermaid syntax specification or Mermaid BNF
- Asks to create, edit, or fix a Mermaid BNF
- Asks to convert Mermaid syntax documentation into more token-efficient form for LLM context

## Directories

- **[./contextualize-mermaid-syntax/syntax/*.md](./syntax/)** - Contains the original syntax
  specification markdown files from the mermaid documentation site.
- **[./contextualize-mermaid-syntax/context/*.md](./context/)** - Contains the transformed,
  token-efficient, contextualized specification (CSpec) markdown files suitable for LLM context.
- **[./contextualize-mermaid-syntax/examples/*.md](./examples/)** - Contains examples of mermaid
  diagrams made by an LLM that used a CSpec from the `context/` directory.

## Step-by-step instructions

1. Identify the diagram type, ask the user if it is unclear which type best fits their need.
2. Read the specification in the [syntax specification directory](./syntax/$ARGUMENTS[0].md)
3. Create or Read the contextualized specification (CSpec) markdown file in the
   [context directory](./context/$ARGUMENTS[0].md)
4. Give the CSpec human-friendly title (`# <title>`) for the diagram type
5. Write short paragraph explanation of the diagram
6. Create a BNF grammar for the syntax, in a code block
   - Do not include `<frontmatter>`
   - Do not specify `<newline>` instead use `"\n"`
   - If there are original diagram type versions, use the latest non-beta version
   - If there are **optional** but working features (e.g. enclosing quotes, back-slashes) that can
     escape special chars, define them in the grammar as being **required**
7. Write token-efficient syntax documentation markdown:
   - Follow the order of the BNF tree: what sections to write should be inferred from matching the
     BNF to the original syntax documentation
   - Do NOT include examples
   - DO NOT include text describing syntax, that is what the BNF is for
     - Instead, write text explaining what that part of the syntax is, and when to use it
   - Many sections in the original are redundant and should be merged whenever coherent to do so
   - Create charts of literal syntax definitions using columns:
     - the literal surrounded in `\``
     - name of the verbatim
     - brief documentation
8. Write an [example diagram](./examples/$ARGUMENTS[0].md) using only the new CSpec from the
   [context directory](./context/). Think up a popularly understood example that reasonably
   showcases the most popular features the diagram type. Extra bonus points if it's funny, too.
   Additionally, in an effort to expose bugs, try to use a comprehensive coverage of different
   features, especially features that have a higher likelihood of exposing bugs in the BNF grammar,
   such as:
   - asymmetric rules (e.g. left-handed, right-handed)
   - names, labels, etc. that have special characters where it is unclear if escaping works
   - long names, labels, etc.
9. Run validation (`npx --yes @mermaid-js/mermaid-cli -i <PATH> 2>&1`) on the
   [example diagram](./examples/$ARGUMENTS[0].md) you just wrote:
   - Read the validation output, and if it errored:
     - Consider: the error message and the error location
     - Consider: did we miss something in the [CSpec](./context/$ARGUMENTS[0].md)?
     - Propose a list of hypotheses for why the error is occurring
     - Start with the most likely hypothesis that is also the easiest to rule-out or confirm:
       - Make a changes to the example that could rule-out or confirm the hypothesis
       - If it didn't fix anything, revert and try something else
       - Keep looping on this numbered step until you get a successful validation
     - Consider: what lead you to write invalid diagram syntax?
     - Consider: is there a change to the BNF grammar that prevents making this mistake again?
     - Consider: did we miss something in the [original syntax spec](./syntax/$ARGUMENTS[0].md)?
   - Fix the example, and consider helpful changes to the CSpec BNF grammar and/or CSpec text
   - Does the BNF grammar have a bug? Is it missing clarification?
10. Re-read the [example diagram](./examples/$ARGUMENTS[0].md), and consider:
    - Did we do an excellent job following the BNF grammar?
    - Does the BNF grammar have any ambiguities we should clarify or bugs we should fix?
    - Is the example a good showcase of the features of the diagram?
    - Do we need to change anything? This is our last chance.
11. Done.
