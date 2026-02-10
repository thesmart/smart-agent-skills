# Sankey Diagram

Sankey diagrams visualize flows between nodes, where link width is proportional to flow quantity.
Use them to show energy transfers, material flows, cost breakdowns, or any source-to-target quantity
mapping.

```bnf
<diagram>       ::= "sankey-beta" "\n" <link>+

<link>          ::= <source> "," <target> "," <value> "\n"

<source>        ::= <csv-field>
<target>        ::= <csv-field>
<value>         ::= <positive-number>

<csv-field>     ::= <unquoted-text>
                  | '"' <quoted-text> '"'
<unquoted-text> ::= (* text without commas or double quotes *)
<quoted-text>   ::= (* text where double quotes are escaped as "" *)

<positive-number> ::= [0-9]+ ["." [0-9]+]

<comment>       ::= "%%" <string>
```

## Links

The syntax is CSV-like with exactly three columns per row: source node name, target node name, and
numeric flow value. Empty lines are allowed for visual grouping.

### Quoting Rules

| Scenario         | Syntax                         |
| ---------------- | ------------------------------ |
| Simple text      | `Source,Target,100`            |
| Text with commas | `Source,"Target, name",100`    |
| Text with quotes | `Source,"Target ""name""",100` |

## Configuration

| Parameter       | Use for                         | Values                               |
| --------------- | ------------------------------- | ------------------------------------ |
| `linkColor`     | Color of flow links             | `source`, `target`, `gradient`, hex  |
| `nodeAlignment` | Horizontal positioning of nodes | `justify`, `center`, `left`, `right` |
| `width`         | Chart width in pixels           | number                               |
| `height`        | Chart height in pixels          | number                               |
| `showValues`    | Display numeric values on links | `true`, `false`                      |
