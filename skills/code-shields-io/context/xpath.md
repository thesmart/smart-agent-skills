# XPath 1.0 Query Syntax

XPath selects nodes from XML documents. Used by shields.io dynamic badges for the `xml` format type.

```bnf
<path>         ::= <absolute> | <relative>
<absolute>     ::= "/" <relative>? | "//" <relative>
<relative>     ::= <step> ("/" <step> | "//" <step>)*
<step>         ::= (<axis> "::")? <node-test> <predicate>*
                 | "." | ".."
<axis>         ::= "child" | "descendant" | "parent" | "ancestor" | "self"
                 | "attribute" | "following-sibling" | "preceding-sibling"
                 | "following" | "preceding" | "descendant-or-self" | "ancestor-or-self"
<node-test>    ::= "*" | <name> | "text()" | "node()" | "comment()"
                 | "processing-instruction(" <literal>? ")"
<predicate>    ::= "[" <expr> "]"
<expr>         ::= <or-expr>
<or-expr>      ::= <and-expr> ("or" <and-expr>)*
<and-expr>     ::= <eq-expr> ("and" <eq-expr>)*
<eq-expr>      ::= <rel-expr> (("=" | "!=") <rel-expr>)*
<rel-expr>     ::= <add-expr> (("<" | ">" | "<=" | ">=") <add-expr>)*
<add-expr>     ::= <mul-expr> (("+" | "-") <mul-expr>)*
<mul-expr>     ::= <unary-expr> (("*" | "div" | "mod") <unary-expr>)*
<unary-expr>   ::= <union-expr> | "-" <unary-expr>
<union-expr>   ::= <primary> ("|" <primary>)*
<primary>      ::= <function-call> | <literal> | <number> | "(" <expr> ")"
```

## Abbreviated Syntax

| Abbreviated | Unabbreviated                  |
| ----------- | ------------------------------ |
| `name`      | `child::name`                  |
| `@attr`     | `attribute::attr`              |
| `.`         | `self::node()`                 |
| `..`        | `parent::node()`               |
| `//`        | `/descendant-or-self::node()/` |

## Predicates

`[n]` selects position `n`. `[last()]` selects last. `[@attr]` tests attribute existence.
`[@attr="val"]` tests attribute value.

## Common Functions

| Function                      | Returns                      |
| ----------------------------- | ---------------------------- |
| `position()`                  | Current position in context  |
| `last()`                      | Context size (last position) |
| `count(node-set)`             | Number of nodes              |
| `name(node-set?)`             | Qualified name               |
| `local-name(node-set?)`       | Local part of name           |
| `text()`                      | Text content (node test)     |
| `contains(str, sub)`          | True if `str` contains `sub` |
| `starts-with(str, prefix)`    | True if prefix matches       |
| `string-length(str?)`         | Character count              |
| `substring(str, start, len?)` | Extract substring            |
| `concat(str, str, ...)`       | Join strings                 |
| `normalize-space(str?)`       | Strip/collapse whitespace    |
| `not(bool)`                   | Logical negation             |

For XML with default namespaces, use `*[local-name()='element']` instead of direct element names.
