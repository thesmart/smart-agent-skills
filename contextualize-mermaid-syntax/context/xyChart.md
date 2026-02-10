# XY Chart

XY charts display data on two axes using bars and/or lines. Use them for visualizing trends,
comparing categories, or combining bar and line representations on the same dataset.

```bnf
<diagram>       ::= "xychart-beta" [" horizontal"] "\n" <statement>+

<statement>     ::= "title " <quoted-or-bare> "\n"
                  | "x-axis " <x-axis-def> "\n"
                  | "y-axis " <y-axis-def> "\n"
                  | "line " <data-array> "\n"
                  | "bar " <data-array> "\n"

<x-axis-def>    ::= <quoted-or-bare> " " <min> " --> " <max>
                  | <quoted-or-bare> " " <data-labels>
<y-axis-def>    ::= <quoted-or-bare> [" " <min> " --> " <max>]

<data-array>    ::= "[" <number> ("," <number>)* "]"
<data-labels>   ::= "[" <label> ("," <label>)* "]"
<label>         ::= <quoted-or-bare>

<min>           ::= <number>
<max>           ::= <number>
<quoted-or-bare>::= '"' <string> '"' | <word>
<word>          ::= (* single word without spaces *)
<number>        ::= [+-]? [0-9]* ["." [0-9]+]

<string>        ::= (* any sequence of characters *)
```

## Orientation

Append `horizontal` after `xychart-beta` to draw the chart horizontally. Default is vertical.

## Title

An optional `title` line sets a heading above the chart. Multi-word titles must be quoted.

## Axes

### x-axis

The x-axis can be categorical (with a bracket-enclosed list of labels) or numeric (with a
`min -->
max` range). Both categorical labels and the title support quoting for multi-word values.

### y-axis

The y-axis is always numeric. Specifying `min --> max` sets an explicit range; omitting it
auto-scales from the data.

Both axes are optional. If omitted, ranges are auto-generated from the data.

## Data Series

| Literal | Use for                           |
| ------- | --------------------------------- |
| `line`  | Line chart connecting data points |
| `bar`   | Bar chart with vertical bars      |

Data arrays are bracket-enclosed comma-separated numbers. Multiple `line` and `bar` statements can
be combined in one diagram.
