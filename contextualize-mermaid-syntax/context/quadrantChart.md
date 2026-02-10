# Quadrant Chart

Quadrant charts plot data points on a two-dimensional grid divided into four labeled quadrants. Use
them to prioritize items across two criteria (e.g., urgency vs. importance, reach vs. engagement).

```bnf
<diagram>       ::= "quadrantChart" "\n" <statement>+

<statement>     ::= "title " <string> "\n"
                  | "x-axis " <string> [" --> " <string>] "\n"
                  | "y-axis " <string> [" --> " <string>] "\n"
                  | "quadrant-1 " <string> "\n"
                  | "quadrant-2 " <string> "\n"
                  | "quadrant-3 " <string> "\n"
                  | "quadrant-4 " <string> "\n"
                  | <point> "\n"
                  | <class-def> "\n"

<point>         ::= <point-name> [":::" <class-name>] ": [" <x> ", " <y> "]" [" " <inline-styles>]
<x>             ::= <decimal>
<y>             ::= <decimal>
<decimal>       ::= (* number between 0.0 and 1.0 *)
<inline-styles> ::= <style-prop> ["," <style-prop>]*
<style-prop>    ::= "radius: " <number>
                  | "color: " <color>
                  | "stroke-color: " <color>
                  | "stroke-width: " <css-length>

<class-def>     ::= "classDef " <class-name> " " <style-prop> ["," <style-prop>]*
<class-name>    ::= <identifier>
<point-name>    ::= <string>

<identifier>    ::= [a-zA-Z_] [a-zA-Z0-9_]*
<string>        ::= (* any sequence of characters *)
```

## Axes

The `x-axis` and `y-axis` statements define labels for each axis. Use the `-->` separator to provide
both a low-end and high-end label. If only one label is given, it appears at the low end.

## Quadrants

Quadrant labels are positioned in the four regions of the chart.

| Literal      | Position     |
| ------------ | ------------ |
| `quadrant-1` | Top right    |
| `quadrant-2` | Top left     |
| `quadrant-3` | Bottom left  |
| `quadrant-4` | Bottom right |

## Points

Points are plotted by name with `[x, y]` coordinates where both values range from 0.0 to 1.0. When
no points are present, axis labels and quadrant text render centered. When points exist, x-axis
labels move to the bottom and quadrant text moves to the top.

## Point Styling

Points can be styled directly with inline properties or via reusable classes defined with `classDef`
and applied with `:::`. Direct styles take precedence over class styles, which take precedence over
theme styles.

| Property       | Use for                   |
| -------------- | ------------------------- |
| `color`        | Fill color of the point   |
| `radius`       | Radius of the point       |
| `stroke-color` | Border color of the point |
| `stroke-width` | Border width of the point |
