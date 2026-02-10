# Sequence Diagram

Sequence diagrams model interactions between participants in time order. Use them to document API
flows, protocol exchanges, or any system where message ordering matters.

```bnf
<diagram>         ::= "sequenceDiagram" "\n" <statement>*

<statement>       ::= <participant-decl>
                    | <message>
                    | <activation>
                    | <note>
                    | <fragment>
                    | <box>
                    | <autonumber>
                    | <link-decl>
                    | <rect>
                    | <create-destroy>
                    | <comment>

<!-- Participants -->

<participant-decl>::= ("participant" | "actor") " " <name> [" as " <alias>] "\n"

<!-- Messages -->

<message>         ::= <name> <arrow> ["+"|"-"] <name> ": " <text> "\n"
<arrow>           ::= "->" | "-->"|"->>" | "-->>" | "<<->>" | "<<-->>" | "-x" | "--x" | "-)" | "--)"

<!-- Activation -->

<activation>      ::= ("activate" | "deactivate") " " <name> "\n"

<!-- Notes -->

<note>            ::= "Note " <position> " " <name> ["," <name>] ": " <text> "\n"
<position>        ::= "right of" | "left of" | "over"

<!-- Fragments -->

<fragment>        ::= <loop> | <alt> | <opt> | <par> | <critical> | <break>
<loop>            ::= "loop " <text> "\n" <statement>* "end" "\n"
<alt>             ::= "alt " <text> "\n" <statement>* ("else " [<text>] "\n" <statement>*)* "end" "\n"
<opt>             ::= "opt " <text> "\n" <statement>* "end" "\n"
<par>             ::= "par " <text> "\n" <statement>* ("and " <text> "\n" <statement>*)* "end" "\n"
<critical>        ::= "critical " <text> "\n" <statement>* ("option " <text> "\n" <statement>*)* "end" "\n"
<break>           ::= "break " <text> "\n" <statement>* "end" "\n"

<!-- Box -->

<box>             ::= "box " [<color> " "] [<text>] "\n" <participant-decl>+ "end" "\n"

<!-- Background -->

<rect>            ::= "rect " <color> "\n" <statement>* "end" "\n"

<!-- Create / Destroy -->

<create-destroy>  ::= "create " <participant-decl>
                    | "destroy " <name> "\n"

<!-- Autonumber -->

<autonumber>      ::= "autonumber" "\n"

<!-- Links -->

<link-decl>       ::= "link " <name> ": " <label> " @ " <url> "\n"
                    | "links " <name> ": " <json-object> "\n"

<!-- Comments -->

<comment>         ::= "%%" <string>

<name>            ::= <identifier>
<alias>           ::= <string>
<color>           ::= <identifier> | "rgb(" <r> "," <g> "," <b> ")" | "rgba(" <r> "," <g> "," <b> "," <a> ")"
<text>            ::= <string>
<identifier>      ::= [a-zA-Z_] [a-zA-Z0-9_ ]*
<string>          ::= (* any sequence of characters *)
```

## Participants

Participants are rendered in declaration order. Use `participant` for box-style or `actor` for
stick-figure rendering. Aliases let you display a long name while using a short identifier.

## Messages

### Arrow Types

| Literal  | Name                   | Use for                        |
| -------- | ---------------------- | ------------------------------ |
| `->`     | Solid, no arrowhead    | Synchronous call (no emphasis) |
| `-->`    | Dotted, no arrowhead   | Return or informational        |
| `->>`    | Solid with arrowhead   | Standard synchronous call      |
| `-->>`   | Dotted with arrowhead  | Standard return message        |
| `<<->>`  | Solid, bidirectional   | Two-way synchronous exchange   |
| `<<-->>` | Dotted, bidirectional  | Two-way asynchronous exchange  |
| `-x`     | Solid with cross       | Failed or terminated message   |
| `--x`    | Dotted with cross      | Failed return                  |
| `-)`     | Solid with open arrow  | Async (fire-and-forget)        |
| `--)`    | Dotted with open arrow | Async return                   |

## Activations

Activations show when a participant is actively processing. Use `activate`/`deactivate` statements,
or append `+` (activate) or `-` (deactivate) to the message arrow. Activations can be stacked.

## Notes

Notes attach commentary to one or two participants. Use `right of`, `left of` for single-
participant notes, or `over` to span across participants (comma-separated).

## Fragments

| Fragment   | Use for                                             |
| ---------- | --------------------------------------------------- |
| `loop`     | Repeated interactions                               |
| `alt/else` | Conditional branching with alternatives             |
| `opt`      | Optional interaction (if without else)              |
| `par/and`  | Parallel execution paths                            |
| `critical` | Atomic actions with optional failure `option` paths |
| `break`    | Early termination of a sequence                     |

All fragments are nestable.

## Boxes

Boxes visually group participants with an optional color and label.

## Background Highlighting

`rect` blocks add colored backgrounds (using `rgb()` or `rgba()`) around a group of statements. They
can be nested.

## Create and Destroy

`create` dynamically introduces a participant mid-sequence. `destroy` removes a participant. Only
the recipient of a message can be created; either sender or recipient can be destroyed.

## Autonumber

`autonumber` adds sequential numbers to all message arrows.

## Actor Menus

`link` and `links` attach clickable popup menus to actors with external URLs.

## Comments

Line comments with `%%` are ignored by the parser. Use `<br/>` for line breaks in message text and
notes.
