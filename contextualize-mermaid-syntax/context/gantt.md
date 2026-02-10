# Gantt Chart

Gantt charts visualize project schedules as horizontal bars on a timeline. Use them for project
planning, task dependencies, milestones, and tracking parallel workstreams.

```bnf
<diagram>        ::= "gantt" "\n" <header>* <body>+

<header>         ::= "title " <string> "\n"
                   | "dateFormat " <date-format> "\n"
                   | "axisFormat " <axis-format> "\n"
                   | "tickInterval " <tick-interval> "\n"
                   | "weekday " <weekday> "\n"
                   | "excludes " <excludes> "\n"
                   | "todayMarker " <marker-style> "\n"
                   | <comment>

<body>           ::= <section>
                   | <task>

<section>        ::= "section " <string> "\n"

<task>           ::= <task-name> " :" [<tags> ","] [<task-id> ","] <timing> "\n"
<tags>           ::= <tag> ["," <tag>]*
<tag>            ::= "done" | "active" | "crit" | "milestone"
<task-id>        ::= <identifier>
<timing>         ::= <end-spec>
                   | <start-spec> "," <end-spec>
<start-spec>     ::= <date> | "after " <task-id> [" " <task-id>]*
<end-spec>       ::= <date> | <duration> | "until " <task-id> [" " <task-id>]*

<duration>       ::= <number> ("d" | "h" | "m" | "w" | "s")
<date>           ::= (* date matching dateFormat *)
<excludes>       ::= "weekends" | <weekday-name> | <date> ["," <excludes>]

<tick-interval>  ::= <number> ("millisecond" | "second" | "minute" | "hour" | "day" | "week" | "month")
<weekday>        ::= "friday" | "saturday" | "sunday" | "monday" | "tuesday" | "wednesday" | "thursday"
<marker-style>   ::= "off" | <css-properties>

<comment>        ::= "%%" <string>

<identifier>     ::= [a-zA-Z_] [a-zA-Z0-9_]*
<string>         ::= (* any sequence of characters *)
```

## Header

### dateFormat

Defines the input date format using dayjs tokens (default: `YYYY-MM-DD`).

### axisFormat

Defines the display format on the time axis using d3-time-format specifiers (default: `%Y-%m-%d`).

### tickInterval

Controls axis tick spacing (e.g., `1day`, `1week`, `2month`).

### weekday

Sets which day week-based tick intervals start on (default: `sunday`).

### excludes

Dates to skip in duration calculations. Accepts `weekends`, day names (e.g., `sunday`), or specific
dates in `dateFormat`. Excluded dates extend task bars rather than creating gaps.

### todayMarker

Style or hide the current-date marker. Set to `off` to hide, or provide CSS properties to style.

## Sections

Sections group related tasks under a named heading. Tasks after a `section` declaration belong to
that section.

## Tasks

Tasks are sequential by default; each starts where the previous ends. A colon separates the task
name from its metadata.

### Tags

| Tag         | Use for                              |
| ----------- | ------------------------------------ |
| `done`      | Completed tasks (filled differently) |
| `active`    | Currently active tasks               |
| `crit`      | Critical path tasks (red highlight)  |
| `milestone` | Single-point-in-time markers         |

Tags are optional and must appear first in the metadata.

### Timing

Tasks support flexible start and end specifications:

| Start        | End          | Effect                                     |
| ------------ | ------------ | ------------------------------------------ |
| _(implicit)_ | `<duration>` | Starts after previous task, lasts duration |
| `<date>`     | `<date>`     | Explicit start and end dates               |
| `<date>`     | `<duration>` | Starts at date, lasts duration             |
| `after <id>` | `<duration>` | Starts after referenced task ends          |
| `after <id>` | `until <id>` | Spans between two referenced tasks         |

Multiple task IDs can follow `after` or `until` (space-separated). For `after`, the latest end date
is used; for `until`, the earliest start date.

## Interactions

Tasks can be made clickable with `click <taskId> href <url>` or `click <taskId> call <callback>()`.
Requires `securityLevel='loose'`.

## Comments

Line comments with `%%` are ignored by the parser.
