# Gitgraph Diagram

Gitgraph diagrams visualize Git commit histories, branching, and merging. Use them to document
branching strategies, release workflows, or explain a commit history.

```bnf
<diagram>        ::= "gitGraph" [" " <orientation>] "\n" <statement>*

<statement>      ::= <commit>
                   | <branch>
                   | <checkout>
                   | <merge>
                   | <cherry-pick>

<commit>         ::= "commit" [" id: " '"' <string> '"'] [" type: " <commit-type>] [" tag: " '"' <string> '"'] "\n"
<commit-type>    ::= "NORMAL" | "REVERSE" | "HIGHLIGHT"

<branch>         ::= "branch " <branch-name> [" order: " <number>] "\n"
<checkout>       ::= ("checkout" | "switch") " " <branch-name> "\n"
<merge>          ::= "merge " <branch-name> [" id: " '"' <string> '"'] [" type: " <commit-type>] [" tag: " '"' <string> '"'] "\n"
<cherry-pick>    ::= "cherry-pick id: " '"' <string> '"' [" parent: " '"' <string> '"'] "\n"

<branch-name>    ::= <identifier> | '"' <string> '"'
<orientation>    ::= "LR:" | "TB:" | "BT:"

<identifier>     ::= [a-zA-Z_] [a-zA-Z0-9_-]*
<string>         ::= (* any sequence of characters *)
```

## Orientation

| Literal | Direction     | Use for                 |
| ------- | ------------- | ----------------------- |
| `LR:`   | Left to right | Default horizontal flow |
| `TB:`   | Top to bottom | Vertical downward flow  |
| `BT:`   | Bottom to top | Vertical upward flow    |

## Commits

Each `commit` creates a new commit on the current branch. Commits receive auto-generated IDs unless
overridden with `id:`.

### Commit Types

| Literal     | Rendering              | Use for                      |
| ----------- | ---------------------- | ---------------------------- |
| `NORMAL`    | Solid circle (default) | Standard commits             |
| `REVERSE`   | Crossed circle         | Reverts or rollbacks         |
| `HIGHLIGHT` | Filled rectangle       | Important or notable commits |

### Tags

Tags are decorative labels (e.g., version numbers) attached to a commit.

## Branches

`branch` creates and switches to a new branch. The diagram always starts on `main`. Branch names
that could conflict with keywords must be quoted.

### Branch Ordering

Use `order: <number>` to control the visual position of a branch. Lower numbers appear first.
Branches without an explicit order appear in declaration order before ordered branches.

## Checkout

`checkout` (or `switch`) sets an existing branch as the current branch for subsequent commits.

## Merge

`merge` joins the head of the named branch into the current branch, creating a merge commit. Merge
commits can be customized with `id:`, `type:`, and `tag:`.

## Cherry-pick

`cherry-pick` copies a commit (by its `id:`) from another branch onto the current branch. When
cherry-picking a merge commit, a `parent:` must be specified identifying which parent to follow.

## Configuration

| Parameter           | Use for                                     | Default |
| ------------------- | ------------------------------------------- | ------- |
| `showBranches`      | Show/hide branch names and lines            | `true`  |
| `showCommitLabel`   | Show/hide commit labels                     | `true`  |
| `mainBranchName`    | Name of the default branch                  | `main`  |
| `mainBranchOrder`   | Visual order position of the main branch    | `0`     |
| `parallelCommits`   | Align equidistant commits at the same level | `false` |
| `rotateCommitLabel` | Rotate commit labels 45 degrees             | `true`  |
