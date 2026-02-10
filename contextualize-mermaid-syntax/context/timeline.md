# Timeline Diagram

Timeline diagrams illustrate a chronology of events organized by time periods. Use them to show
project milestones, historical events, or any sequence of happenings over time.

```bnf
<diagram>       ::= "timeline" "\n" ["title " <string> "\n"] <body>+

<body>          ::= <section>
                  | <time-period>

<section>       ::= "section " <string> "\n"

<time-period>   ::= <period-text> " : " <event> [" : " <event>]* "\n" [<continuation>]*
<continuation>  ::= <whitespace> ": " <event> "\n"

<period-text>   ::= <string>
<event>         ::= <string>

<string>        ::= (* any sequence of characters *)
```

## Title

An optional `title` line sets a heading displayed above the diagram.

## Sections

Sections group time periods into named phases. All time periods after a `section` declaration belong
to that section until the next section. Sections share a color scheme for their contained time
periods. Without sections, each time period gets its own color.

## Time Periods

Each time period has a label (date, era, or any text) followed by one or more events separated by
`:`. Events can also be added on continuation lines (indented lines starting with `:`).

Time periods render left-to-right in declaration order. Events within a time period render top-to-
bottom.

## Configuration

| Parameter           | Use for                                         | Default |
| ------------------- | ----------------------------------------------- | ------- |
| `disableMulticolor` | All time periods use the same color when `true` | `false` |
