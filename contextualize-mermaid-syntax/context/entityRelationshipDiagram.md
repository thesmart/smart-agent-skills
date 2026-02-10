# Entity Relationship Diagram

ER diagrams model entities (things of interest) and the relationships between them using crow's foot
notation. Entities are always named with singular nouns. Use ER diagrams for logical data modeling,
relational database design, or documenting domain structure. Attributes can optionally be included
to clarify entity purpose without being exhaustive.

```bnf
<diagram>              ::= "erDiagram" "\n" <statement>*

<statement>            ::= <relationship>
                         | <entity-def>
                         | <entity-name>
                         | <comment>

<!-- Relationships -->

<relationship>         ::= <entity-name> " " <relationship-spec> " " <entity-name> " : " <relationship-label>
<relationship-spec>    ::= <left-symbol-card> <identification> <right-symbol-card>
                         | <word-cardinality>
<identification>       ::= "--" | ".."
<left-symbol-card>     ::= "|o" | "||" | "}o" | "}|"
<right-symbol-card>    ::= "o|" | "||" | "o{" | "|{"

<word-cardinality>     ::= <word-card-value> " " <word-identification> " " <word-card-value>
<word-card-value>      ::= "zero or one"
                         | "one or zero"
                         | "one or more"
                         | "one or many"
                         | "many(1)"
                         | "1+"
                         | "zero or more"
                         | "zero or many"
                         | "many(0)"
                         | "0+"
                         | "only one"
                         | "1"
<word-identification>  ::= "to"
                         | "optionally to"

<relationship-label>   ::= <word>
                         | '"' <string> '"'

<!-- Entity definition with attributes -->

<entity-def>           ::= <entity-name> [<entity-alias>] " {" "\n" <attribute>* "}"
<entity-alias>         ::= "[" <alias-value> "]"
<alias-value>          ::= <word>
                         | '"' <string> '"'

<!-- Attributes -->

<attribute>            ::= <type> " " <name> [" " <key-list>] [" " <attr-comment>]
<type>                 ::= [a-zA-Z] [a-zA-Z0-9\-_()\[\]]*
<name>                 ::= [a-zA-Z*] [a-zA-Z0-9\-_()\[\]]*
<key-list>             ::= <key> [", " <key>]*
<key>                  ::= "PK" | "FK" | "UK"
<attr-comment>         ::= '"' <string> '"'

<!-- Entity name -->

<entity-name>          ::= [a-zA-Z_] [a-zA-Z0-9\-]*

<!-- Comments -->

<comment>              ::= "%%" <string>

<!-- Terminals -->

<word>                 ::= [a-zA-Z_] [a-zA-Z0-9_-]*
<string>               ::= (* any sequence of characters excluding double quotes *)
```

## Relationships

Relationships connect two entities with a cardinality specification and a label describing the
relationship from the first entity's perspective. A statement with only an entity name (no
relationship) renders a standalone entity.

### Cardinality (Symbol Notation)

Each cardinality marker has two characters: the outermost represents a maximum, the innermost a
minimum.

| Left   | Right  | Meaning                       |
| ------ | ------ | ----------------------------- |
| `\|o`  | `o\|`  | Zero or one                   |
| `\|\|` | `\|\|` | Exactly one                   |
| `}o`   | `o{`   | Zero or more (no upper limit) |
| `}\|`  | `\|{`  | One or more (no upper limit)  |

### Cardinality (Word Notation)

An alternative verbose syntax using natural language. Word cardinalities use `to` for identifying
and `optionally to` for non-identifying relationships.

| Word           | Equivalent   |
| -------------- | ------------ |
| `zero or one`  | Zero or one  |
| `one or zero`  | Zero or one  |
| `one or more`  | One or more  |
| `one or many`  | One or more  |
| `many(1)`      | One or more  |
| `1+`           | One or more  |
| `zero or more` | Zero or more |
| `zero or many` | Zero or more |
| `many(0)`      | Zero or more |
| `0+`           | Zero or more |
| `only one`     | Exactly one  |
| `1`            | Exactly one  |

### Identification

Controls whether the relationship line is solid or dashed.

| Literal         | Name            | Use for                                      |
| --------------- | --------------- | -------------------------------------------- |
| `--`            | Identifying     | Child entity cannot exist without the parent |
| `..`            | Non-identifying | Both entities can exist independently        |
| `to`            | Identifying     | Word-notation equivalent of `--`             |
| `optionally to` | Non-identifying | Word-notation equivalent of `..`             |

### Relationship Labels

Labels describe the relationship from the first entity's perspective. Multi-word labels must be
wrapped in double quotes. An empty quoted string (`""`) produces no label.

## Entity Definitions

Entities are introduced explicitly with a block of attributes or implicitly by appearing in a
relationship statement. Entity names must begin with a letter or underscore and may contain letters,
digits, and hyphens.

### Entity Aliases

An alias in square brackets replaces the entity name in the rendered diagram. Use double quotes
inside the brackets for aliases with spaces or special characters.

## Attributes

Attributes define the structure of an entity. Each attribute has a type and name, with optional key
constraints and a comment.

### Keys

| Literal | Name        | Use for                                    |
| ------- | ----------- | ------------------------------------------ |
| `PK`    | Primary Key | Uniquely identifies each entity instance   |
| `FK`    | Foreign Key | References a primary key in another entity |
| `UK`    | Unique Key  | Enforces uniqueness on the attribute       |

Multiple keys can be combined with commas (e.g., `PK, FK`).

### Attribute Comments

A double-quoted string at the end of an attribute line adds a descriptive comment rendered in the
diagram.

## Styling

### Config Options

| Name     | Use for                                                              |
| -------- | -------------------------------------------------------------------- |
| `fill`   | Background color of an entity or attribute                           |
| `stroke` | Border color of an entity or attribute, line color of a relationship |

### CSS Selectors

| Selector                   | Use for                                               |
| -------------------------- | ----------------------------------------------------- |
| `.er.attributeBoxEven`     | The box containing attributes on even-numbered rows   |
| `.er.attributeBoxOdd`      | The box containing attributes on odd-numbered rows    |
| `.er.entityBox`            | The box representing an entity                        |
| `.er.entityLabel`          | The label for an entity                               |
| `.er.relationshipLabel`    | The label for a relationship                          |
| `.er.relationshipLabelBox` | The box surrounding a relationship label              |
| `.er.relationshipLine`     | The line representing a relationship between entities |

## Comments

Line comments for excluding content from rendering. Use them to document diagram source or
temporarily disable statements.
