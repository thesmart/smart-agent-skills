# State Diagram

State diagrams describe the behavior of a system as a finite set of states and transitions between
them. Use them for modeling object lifecycles, protocol states, UI flows, or any system with
distinct modes of operation.

```bnf
<diagram>         ::= "stateDiagram-v2" "\n" <statement>*

<statement>       ::= <state-def>
                    | <transition>
                    | <composite>
                    | <choice>
                    | <fork-join>
                    | <note>
                    | <concurrency>
                    | <direction>
                    | <style-stmt>
                    | <comment>

<!-- States -->

<state-def>       ::= <state-id> [<style-class>] "\n"
                    | <state-id> " : " <description> "\n"
                    | "state " '"' <description> '" as ' <state-id> "\n"

<!-- Transitions -->

<transition>      ::= <state-ref> " --> " <state-ref> [" : " <label>] "\n"
<state-ref>       ::= <state-id> [<style-class>]
                    | "[*]"
<state-id>        ::= <identifier>
<style-class>     ::= ":::" <identifier>

<!-- Composite states -->

<composite>       ::= "state " <state-id> " {" "\n" <statement>* "}"

<!-- Special states -->

<choice>          ::= "state " <state-id> " <<choice>>"
<fork-join>       ::= "state " <state-id> " <<fork>>"
                    | "state " <state-id> " <<join>>"

<!-- Notes -->

<note>            ::= "note " <position> " " <state-id> "\n" <text> "\n" "end note"
                    | "note " <position> " " <state-id> " : " <text> "\n"
<position>        ::= "right of" | "left of"

<!-- Concurrency -->

<concurrency>     ::= "--"

<!-- Direction -->

<direction>       ::= "direction " ("TB" | "TD" | "BT" | "RL" | "LR")

<!-- Styling -->

<style-stmt>      ::= "classDef " <identifier> " " <css-properties>
                    | "class " <state-id> ["," <state-id>]* " " <identifier>
<css-properties>  ::= <property> ("," <property>)*
<property>        ::= <identifier> ":" <string>

<!-- Comments -->

<comment>         ::= "%%" <string>

<label>           ::= (* any characters except ":" and "\n" *)
<identifier>      ::= [a-zA-Z_] [a-zA-Z0-9_]*
<string>          ::= (* any sequence of characters *)
```

## States

States can be declared implicitly by referencing them in transitions, or explicitly with a
description. Use `state "description" as id` for names with spaces.

### Start and End

`[*]` represents the start or end pseudo-state. When used as a transition source it is the start
state; when used as a target it is the end state.

## Transitions

Transitions use `-->` with an optional label after `:` describing the trigger or guard condition.
Labels cannot contain `:` or newline characters.

## Composite States

Composite states contain nested states and transitions within `{}`. They can be nested arbitrarily
deep. Transitions between internal states of different composite states are not allowed.

## Choice

`<<choice>>` creates a decision pseudo-state for conditional branching based on guard conditions on
outgoing transitions.

## Fork and Join

`<<fork>>` splits a transition into concurrent paths. `<<join>>` synchronizes concurrent paths back
into a single flow.

## Notes

Notes can be placed `right of` or `left of` a state. Single-line notes use `: text` syntax.
Multi-line notes use `end note` to close.

## Concurrency

Use `--` inside a composite state to separate concurrent regions. Each region has its own
independent set of states and transitions.

## Direction

Controls diagram layout orientation. Default is top-to-bottom.

| Literal | Direction     |
| ------- | ------------- |
| `TB`    | Top to bottom |
| `BT`    | Bottom to top |
| `LR`    | Left to right |
| `RL`    | Right to left |

## Styling

Define reusable styles with `classDef` and apply them with `class` or `:::` on state references.
Cannot be applied to start/end states or within composite states.

## Comments

Line comments with `%%` are ignored by the parser.
