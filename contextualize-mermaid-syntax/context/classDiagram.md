# Class Diagram

UML class diagram showing classes, attributes, methods, and relationships. Used for object-oriented
modeling of system structure.

```bnf
<diagram>          ::= "classDiagram" "\n" <statement>*

<statement>        ::= <class-def>
                     | <member-def>
                     | <relationship>
                     | <namespace>
                     | <annotation>
                     | <note>
                     | <direction>
                     | <interaction>
                     | <lollipop>
                     | <style-stmt>
                     | <class-def-stmt>
                     | <css-class-stmt>
                     | <comment>

<!-- Class definition -->

<class-def>        ::= "class " <class-name> [<generic>] [<class-label>] [<style-class>] ["{" "\n" [<annotation-inline>] <member>* "}"]
<class-name>       ::= <identifier> | "`" <string> "`"
<class-label>      ::= '["' <string> '"]'
<generic>          ::= "~" <identifier> "~"
<style-class>      ::= ":::" <identifier>

<!-- Members (attributes and methods) -->

<member-def>       ::= <class-name> " : " <member>
                     | <class-name> ": " <member>
<member>           ::= [<visibility>] [<type> " "] <identifier> ["(" [<params>] ")" [" " <return-type>]] [<classifier>]
<visibility>       ::= "+" | "-" | "#" | "~"
<classifier>       ::= "*" | "$"
<type>             ::= <identifier> ["~" <type> "~"]
<return-type>      ::= <type>
<params>           ::= <type> [" " <identifier>] ["," <params>]

<!-- Relationships -->

<relationship>     ::= <class-name> [" " <cardinality>] " " <arrow> " " [<cardinality> " "] <class-name> [" : " <label>]
<arrow>            ::= [<relation-type>] <link> [<relation-type>]
<relation-type>    ::= "<|" | "|>" | "*" | "o" | ">" | "<"
<link>             ::= "--" | ".."
<cardinality>      ::= '"' <cardinality-value> '"'
<cardinality-value>::= "1" | "0..1" | "1..*" | "*" | "n" | "0..n" | "1..n" | <string>
<label>            ::= <string>

<!-- Lollipop interfaces -->

<lollipop>         ::= <class-name> " --() " <class-name>
                     | <class-name> " ()-- " <class-name>

<!-- Namespace -->

<namespace>        ::= "namespace " <identifier> " {" "\n" <class-def>* "}"

<!-- Annotations -->

<annotation>       ::= "<<" <annotation-text> ">> " <class-name>
<annotation-inline>::= "<<" <annotation-text> ">>" "\n"
<annotation-text>  ::= "Interface" | "Abstract" | "Service" | "Enumeration" | <string>

<!-- Notes -->

<note>             ::= "note " '"' <string> '"'
                     | "note for " <class-name> " " '"' <string> '"'

<!-- Direction -->

<direction>        ::= "direction " ("TB" | "TD" | "BT" | "RL" | "LR")

<!-- Interaction -->

<interaction>      ::= "click " <class-name> " call " <identifier> "()" [" " '"' <string> '"']
                     | "click " <class-name> " href " '"' <string> '"' [" " '"' <string> '"']
                     | "link " <class-name> " " '"' <string> '"' [" " '"' <string> '"']
                     | "callback " <class-name> " " '"' <identifier> '"' [" " '"' <string> '"']

<!-- Styling -->

<style-stmt>       ::= "style " <class-name> " " <css-properties>
<class-def-stmt>   ::= "classDef " <identifier> " " <css-properties>
<css-class-stmt>   ::= "cssClass " '"' <class-name> [("," <class-name>)*] '"' " " <identifier>
<css-properties>   ::= <property> ("," <property>)*
<property>         ::= <identifier> ":" <string>

<!-- Comments -->

<comment>          ::= "%%" <string>

<!-- Terminals -->

<identifier>       ::= [a-zA-Z_] [a-zA-Z0-9_-]*
<string>           ::= (* any sequence of characters *)
```

## Class Definition

A class is the primary building block. Classes can be introduced explicitly or implicitly when
referenced in a relationship. Use class labels when the display name needs special characters or
differs from the identifier. Use backtick-escaped names when the identifier itself contains special
characters.

Generics model parameterized types. Use them to represent containers, collections, or any
type-parameterized class. Nested generics are supported but comma-separated type parameters are not.

## Members

Members model the attributes and operations of a class. Attributes represent state (fields,
properties); methods represent behavior (functions, operations).

### Visibility

UML access modifiers indicating encapsulation level.

| Literal | Name             | Use for                                 |
| ------- | ---------------- | --------------------------------------- |
| `+`     | Public           | Accessible to all classes               |
| `-`     | Private          | Accessible only within the owning class |
| `#`     | Protected        | Accessible to subclasses                |
| `~`     | Package/Internal | Accessible within the same package      |

### Classifiers

Modifiers indicating special member behavior.

| Literal | Name     | Use for                                       |
| ------- | -------- | --------------------------------------------- |
| `*`     | Abstract | Methods that must be overridden by subclasses |
| `$`     | Static   | Members belonging to the class, not instances |

## Relationships

Relationships represent the structural and behavioral connections between classes. Solid links
indicate stronger, compile-time dependencies; dashed links indicate weaker, runtime dependencies.

### Relation Types

| Literal | Name        | Use for                                                |
| ------- | ----------- | ------------------------------------------------------ |
| `<\|`   | Inheritance | "Is-a" relationship (extends / implements)             |
| `\|>`   | Inheritance | Same as above, opposite direction                      |
| `*`     | Composition | Strong ownership — part cannot exist without the whole |
| `o`     | Aggregation | Weak ownership — part can exist independently          |
| `>`     | Association | General "uses" or "knows about" relationship           |
| `<`     | Association | Same as above, opposite direction                      |

### Combined Arrows

| Arrow      | Use for                                                |
| ---------- | ------------------------------------------------------ |
| `<\|--`    | Class inheritance (solid = compile-time)               |
| `*--`      | Composition — lifecycle-bound containment              |
| `o--`      | Aggregation — independent containment                  |
| `-->`      | Directed association — one class references another    |
| `--`       | Undirected link between classes                        |
| `..\|>`    | Realization — a class implements an interface (dashed) |
| `..>`      | Dependency — runtime or transient usage                |
| `..`       | Undirected dashed link                                 |
| `<\|--\|>` | Bidirectional relationship for N:M associations        |

### Cardinality

Cardinality expresses how many instances of one class relate to instances of another. Use it to
document multiplicity constraints on associations.

| Value  | Meaning       |
| ------ | ------------- |
| `1`    | Exactly one   |
| `0..1` | Zero or one   |
| `1..*` | One or more   |
| `*`    | Many          |
| `n`    | n (where n>1) |
| `0..n` | Zero to n     |
| `1..n` | One to n      |

## Lollipop Interfaces

Lollipop notation is a compact UML way to show that a class provides or requires an interface,
without defining a separate interface class. Use it when the interface identity matters less than
the fact that one exists. Can also be used to split-up diagrams in order to provide less detail now
and then more detail later.

## Namespaces

Namespaces visually group related classes into a bounded region. Use them to represent packages,
modules, or bounded contexts.

## Annotations

Annotations are stereotypes that classify the nature of a class. Use `<<Interface>>` for contracts,
`<<Abstract>>` for base classes, `<<Service>>` for service layers, `<<Enumeration>>` for fixed value
sets, or any custom stereotype.

## Notes

Notes attach free-text commentary to the diagram or to a specific class. Use them for design
rationale, constraints, or TODOs that don't fit into the class structure. Supports `\n` for line
breaks.

## Direction

Controls the layout orientation of the diagram. Use when the default top-to-bottom flow doesn't suit
the relationship structure.

## Interactions

Interactions make classes clickable in rendered HTML. Use callbacks for in-page JavaScript behavior
or href links to navigate to external documentation. Requires `securityLevel='loose'`.

## Styling

Styling overrides the default appearance of individual classes or groups of classes. Use inline
styles for one-off customization, define reusable style classes with `classDef`, and apply them via
`:::` shorthand or `cssClass`. The `:::` shorthand cannot be used in the same statement as a
relationship.

## Comments

Line comments for excluding content from rendering. Use them to document diagram source or
temporarily disable statements.
