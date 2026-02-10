# Block Diagram

Block diagrams represent system architectures, process flows, or component layouts using positioned
blocks on a grid. Unlike flowcharts, block diagrams give the author full control over block
placement via a column-based layout system.

```bnf
<diagram>        ::= "block-beta" "\n" <statement>*

<statement>      ::= <columns>
                   | <block-item>
                   | <composite>
                   | <edge>
                   | <style-stmt>
                   | <class-def-stmt>
                   | <class-stmt>
                   | <comment>

<!-- Layout -->

<columns>        ::= "columns " <number> "\n"

<!-- Blocks -->

<block-item>     ::= <block-ref> [<shape>] [":" <span>] "\n"
                   | "space" [":" <span>] "\n"
                   | <block-arrow> "\n"
<block-ref>      ::= <identifier>
<span>           ::= <number>

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

<block-arrow>    ::= <identifier> '<["' <text> '"]>(' <arrow-dir> ")"
<arrow-dir>      ::= "right" | "left" | "up" | "down" | "x" | "y" | <arrow-dir> ", " <arrow-dir>

<!-- Composite blocks -->

<composite>      ::= "block" [":" <identifier>] [":" <span>] "\n" <statement>* "end"

<!-- Edges -->

<edge>           ::= <identifier> " --> " <identifier> "\n"
                   | <identifier> " -- " '"' <text> '"' " --> " <identifier> "\n"

<!-- Styling -->

<style-stmt>     ::= "style " <identifier> " " <css-properties>
<class-def-stmt> ::= "classDef " <identifier> " " <css-properties>
<class-stmt>     ::= "class " <identifier> ["," <identifier>]* " " <identifier>
<css-properties> ::= <property> ("," <property>)*
<property>       ::= <identifier> ":" <string>

<!-- Comments -->

<comment>        ::= "%%" <string>

<identifier>     ::= [a-zA-Z_] [a-zA-Z0-9_]*
<text>           ::= <string>
<string>         ::= (* any sequence of characters *)
```

## Layout

`columns N` sets how many columns the grid has. Blocks fill left-to-right, wrapping to the next row
when a row is full. The default column count is automatic (all blocks in one row).

## Blocks

Blocks are placed in grid order. Each block has an identifier and an optional shape. Use `:<number>`
to make a block span multiple columns.

### Shapes

Block diagrams support the same shapes as flowcharts (rectangle, rounded, circle, rhombus, hexagon,
cylinder, stadium, subroutine, parallelogram, trapezoid, double circle, and asymmetric).

### Space Blocks

`space` inserts empty grid cells. Use `space:<number>` to span multiple columns.

### Block Arrows

Block arrows are directional arrow shapes that visually indicate flow direction within the grid
layout.

| Direction | Use for             |
| --------- | ------------------- |
| `right`   | Rightward flow      |
| `left`    | Leftward flow       |
| `up`      | Upward flow         |
| `down`    | Downward flow       |
| `x`       | Horizontal spanning |
| `y`       | Vertical spanning   |

## Composite Blocks

`block...end` creates a nested container. Composite blocks can have their own `columns` setting and
contain any block items. Use `block:<id>` to give it a referenceable identifier and `:<span>` for
column width.

## Edges

Blocks can be connected with `-->` arrows after they are defined. Text labels can be added between
quotes.

## Styling

Use `style` for individual block styling, `classDef` for reusable style classes, and `class` to
apply them.

## Comments

Line comments with `%%` are ignored by the parser.
