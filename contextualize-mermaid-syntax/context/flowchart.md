# Flowchart

Flowcharts model processes and decision logic using nodes (shapes) and edges (arrows). Use them for
algorithms, workflows, decision trees, or any step-by-step process visualization.

```bnf
<diagram>        ::= "flowchart" [" " <direction>] "\n" <statement>*

<statement>      ::= <node-stmt>
                   | <edge-stmt>
                   | <subgraph>
                   | <direction-stmt>
                   | <interaction>
                   | <style-stmt>
                   | <class-def-stmt>
                   | <class-stmt>
                   | <link-style-stmt>
                   | <comment>

<!-- Direction -->

<direction>      ::= "TB" | "TD" | "BT" | "RL" | "LR"
<direction-stmt> ::= "direction " <direction>

<!-- Nodes -->

<node-stmt>      ::= <node-id> [<shape>] [<style-class>]
<node-id>        ::= <identifier>
<shape>          ::= "[" <text> "]"
                   | "(" <text> ")"
                   | "((" <text> "))"
                   | "(((" <text> ")))"
                   | "([" <text> "])"
                   | "[[" <text> "]]"
                   | "[(" <text> ")]"
                   | "{" <text> "}"
                   | "{{" <text> "}}"
                   | ">" <text> "]"
                   | "[/" <text> "/]"
                   | "[\\" <text> "\\]"
                   | "[/" <text> "\\]"
                   | "[\\" <text> "/]"
<style-class>    ::= ":::" <identifier>

<!-- Edges -->

<edge-stmt>      ::= <node-ref> (" " <link> " " <node-ref>)+
<node-ref>       ::= <node-id> [<shape>] [<style-class>]
                   | <node-ref> " & " <node-ref>
<link>           ::= <arrow> ["|" <text> "|"]
                   | <text-link>
<arrow>          ::= "-->" | "---" | "-.->"|"-.-" | "==>" | "===" | "~~~"
                   | "--o" | "--x" | "o--o" | "<-->" | "x--x"
<text-link>      ::= "-- " <text> " -->" | "-- " <text> " ---"
                   | "-. " <text> " .->" | "== " <text> " ==>"

<!-- Subgraphs -->

<subgraph>       ::= "subgraph " [<identifier> " "] ["[" <text> "]"] "\n" <statement>* "end"

<!-- Interactions -->

<interaction>    ::= "click " <node-id> " " <click-action> [" " '"' <tooltip> '"'] [" " <target>]
<click-action>   ::= "callback " <identifier>
                   | "call " <identifier> "()"
                   | "href " '"' <url> '"'
                   | '"' <url> '"'
<target>         ::= "_self" | "_blank" | "_parent" | "_top"

<!-- Styling -->

<style-stmt>     ::= "style " <node-id> " " <css-properties>
<class-def-stmt> ::= "classDef " <identifier> " " <css-properties>
<class-stmt>     ::= "class " <node-id> ["," <node-id>]* " " <identifier>
<link-style-stmt>::= "linkStyle " <link-index> ["," <link-index>]* " " <css-properties>
<css-properties> ::= <property> ("," <property>)*
<property>       ::= <identifier> ":" <string>

<!-- Comments -->

<comment>        ::= "%%" <string>

<identifier>     ::= [a-zA-Z_] [a-zA-Z0-9_]*
<text>           ::= <string> | '"`' <markdown-text> '`"'
<string>         ::= (* any sequence of characters *)
```

## Direction

| Literal | Name          | Use for                  |
| ------- | ------------- | ------------------------ |
| `TB`    | Top to bottom | Default vertical flow    |
| `TD`    | Top-down      | Same as TB               |
| `BT`    | Bottom to top | Upward flow              |
| `RL`    | Right to left | Reversed horizontal flow |
| `LR`    | Left to right | Standard horizontal flow |

## Node Shapes

| Literal      | Name              | Use for                          |
| ------------ | ----------------- | -------------------------------- |
| `[text]`     | Rectangle         | Process steps, default shape     |
| `(text)`     | Rounded rectangle | Start/end or softer steps        |
| `((text))`   | Circle            | Connectors or central nodes      |
| `(((text)))` | Double circle     | Critical or terminal nodes       |
| `([text])`   | Stadium           | Events or actions                |
| `[[text]]`   | Subroutine        | Predefined process               |
| `[(text)]`   | Cylinder          | Database or storage              |
| `{text}`     | Rhombus           | Decision points                  |
| `{{text}}`   | Hexagon           | Preparation or setup             |
| `>text]`     | Asymmetric        | Input or signal (right-pointing) |
| `[/text/]`   | Parallelogram     | Input/output                     |
| `[\text\]`   | Parallelogram alt | Alternate input/output           |
| `[/text\]`   | Trapezoid         | Manual operation                 |
| `[\text/]`   | Trapezoid alt     | Alternate manual operation       |

## Edges

Edges connect nodes using arrow syntax. Extra dashes lengthen the link (e.g., `---->` spans more
ranks than `-->`).

### Line Styles

| Style  | No arrow | With arrow | Use for                     |
| ------ | -------- | ---------- | --------------------------- |
| Solid  | `---`    | `-->`      | Direct relationships        |
| Dotted | `-.-`    | `-.->`     | Weak or optional dependency |
| Thick  | `===`    | `==>`      | Emphasized relationships    |

### Arrow Ends

| Literal | Name   | Use for                     |
| ------- | ------ | --------------------------- |
| `>`     | Arrow  | Directional flow            |
| `o`     | Circle | Bidirectional connectors    |
| `x`     | Cross  | Termination or cancellation |

### Link Text

Text can be added to links either inline (`A -->|text| B`) or using the embedded form
(`A -- text --> B`).

### Chaining

Multiple links can be chained in one statement (`A --> B --> C`). Use `&` to fan out
(`A & B --> C & D`).

## Subgraphs

Subgraphs group nodes into a labeled bounding box. They can be nested, connected to other nodes, and
given their own `direction` statement. If any node inside a subgraph links externally, the
subgraph's direction is overridden by the parent graph.

## Markdown Strings

Wrap text in ``"`...`"`` for Markdown formatting (bold, italics, line breaks) in node labels, edge
labels, and subgraph labels.

## Interactions

Interactions make nodes clickable via JavaScript callbacks or hyperlinks. Requires
`securityLevel='loose'`.

## Styling

Use `style` for one-off node styling, `classDef` to define reusable style classes, `class` or `:::`
to apply them, and `linkStyle` to style edges by their declaration order (zero-indexed). A class
named `default` applies to all nodes without explicit styles.

## Comments

Line comments with `%%` are ignored by the parser.
