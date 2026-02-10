# Pie Chart

Pie charts divide a circle into proportional slices to illustrate numerical ratios. Use them to show
part-to-whole relationships when you have a small number of categories (typically 2-7). Slices are
ordered clockwise in the order labels are declared.

```bnf
<diagram>       ::= "pie" [" showData"] "\n" ["title " <string> "\n"] <slice>+

<slice>         ::= '"' <label> '" : ' <value> "\n"

<label>         ::= <string>
<value>         ::= <positive-number>

<comment>       ::= "%%" <string>

<positive-number> ::= [0-9]+ ["." [0-9]{0,2}]
<string>        ::= (* any sequence of characters *)
```

## Diagram Header

The diagram begins with `pie`. Optionally append `showData` to render the raw numeric values after
the legend text.

## Title

An optional `title` line sets a heading displayed above the chart.

## Slices

Each slice is a quoted label followed by `:` and a positive numeric value (up to two decimal
places). Slices render clockwise in declaration order. Values represent relative proportions, not
percentages.

## Configuration

| Parameter      | Use for                                                    | Default |
| -------------- | ---------------------------------------------------------- | ------- |
| `textPosition` | Axial position of slice labels, 0.0 (center) to 1.0 (edge) | `0.75`  |

## Comments

Line comments starting with `%%` are ignored by the parser.
