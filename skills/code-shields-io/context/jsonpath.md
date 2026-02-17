# JSONPath Query Syntax

JSONPath selects values from JSON/YAML/TOML documents. Used by shields.io dynamic badges for `json`,
`yaml`, and `toml` format types.

```bnf
<query>        ::= "$" <segments>
<segments>     ::= (<segment>)*
<segment>      ::= "[" <selectors> "]" | "." <name> | ".." <selectors>
<selectors>    ::= <selector> ("," <selector>)*
<selector>     ::= <name-sel> | <index-sel> | <slice-sel> | "*" | <filter-sel>
<name-sel>     ::= "'" <name> "'" | '"' <name> '"'
<index-sel>    ::= <integer>
<slice-sel>    ::= [<start>] ":" [<end>] [":" <step>]
<filter-sel>   ::= "?" <logical-expr>
<logical-expr> ::= <and-expr> ("||" <and-expr>)*
<and-expr>     ::= <comp-expr> ("&&" <comp-expr>)*
<comp-expr>    ::= <value> (("==" | "!=" | "<" | "<=" | ">" | ">=") <value>)?
<value>        ::= <literal> | "@" <segments> | "$" <segments> | <function-call>
<function-call>::= <name> "(" [<arg> ("," <arg>)*] ")"
```

## Operators

| Operator           | Meaning                         |
| ------------------ | ------------------------------- |
| `$`                | Root node                       |
| `.name`            | Child member                    |
| `['name']`         | Child member (bracket notation) |
| `[0]`              | Array index (zero-based)        |
| `[-1]`             | Index from end                  |
| `[start:end:step]` | Array slice                     |
| `[*]`              | All children                    |
| `..`               | Recursive descent (any depth)   |
| `@`                | Current node (in filters)       |
| `?expr`            | Filter                          |

## Functions

| Function             | Returns                        |
| -------------------- | ------------------------------ |
| `length(expr)`       | Element count or string length |
| `count(query)`       | Number of nodes matched        |
| `match(str, regex)`  | True if full regex match       |
| `search(str, regex)` | True if regex found anywhere   |
| `value(query)`       | Value from singular query      |

## Filter Operators

Logical: `&&` (AND), `||` (OR), `!` (NOT). Comparison: `==`, `!=`, `<`, `<=`, `>`, `>=`. Literals in
filters: `true`, `false`, `null`, numbers, quoted strings.
