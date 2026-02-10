# User Journey Diagram

User journey diagrams map the steps a user takes to complete a task, scored by satisfaction (1-5).
Use them to identify pain points and improvement opportunities in workflows, onboarding flows, or
feature interactions.

```bnf
<diagram>       ::= "journey" "\n" ["title " <string> "\n"] <body>+

<body>          ::= <section>
                  | <task>

<section>       ::= "section " <string> "\n"

<task>          ::= <task-name> ": " <score> ": " <actors> "\n"
<task-name>     ::= <string>
<score>         ::= "1" | "2" | "3" | "4" | "5"
<actors>        ::= <actor> [", " <actor>]*
<actor>         ::= <string>

<string>        ::= (* any sequence of characters *)
```

## Title

An optional `title` line sets a heading displayed above the diagram.

## Sections

Sections group related tasks into named phases. All tasks after a `section` declaration belong to
that section until the next section is declared.

## Tasks

Each task has a name, a satisfaction score, and a comma-separated list of actors involved.

### Score

| Value | Meaning           |
| ----- | ----------------- |
| `5`   | Very satisfied    |
| `4`   | Satisfied         |
| `3`   | Neutral           |
| `2`   | Dissatisfied      |
| `1`   | Very dissatisfied |
