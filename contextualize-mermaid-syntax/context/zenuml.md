# ZenUML Sequence Diagram

ZenUML renders sequence diagrams using a programming-language-inspired syntax. Use it when you
prefer a code-like notation for modeling interactions between participants with method calls,
conditions, loops, and parallel blocks.

```bnf
<diagram>         ::= "zenuml" "\n" ["title " <string> "\n"] <statement>*

<statement>       ::= <participant-decl>
                    | <sync-message>
                    | <async-message>
                    | <creation>
                    | <reply>
                    | <fragment>
                    | <comment>

<!-- Participants -->

<participant-decl>::= [<annotator> " "] <name> [" as " <alias>] "\n"
<annotator>       ::= "@Actor" | "@Database" | "@Boundary" | "@Control" | "@Entity" | "@Queue"

<!-- Messages -->

<sync-message>    ::= <name> "." <method> ["(" [<params>] ")"] [" {" "\n" <statement>* "}"] "\n"
<async-message>   ::= <name> "->" <name> ": " <text> "\n"
<creation>        ::= "new " <name> ["(" [<params>] ")"] "\n"
<reply>           ::= [<type> " "] <var> " = " <sync-message>
                    | "return " <text> "\n"
                    | "@return" "\n" <async-message>

<!-- Fragments -->

<fragment>        ::= <alt> | <loop> | <opt> | <par> | <try-catch>
<alt>             ::= "if(" <condition> ") {" "\n" <statement>* "}" [" else if(" <condition> ") {" "\n" <statement>* "}"]* [" else {" "\n" <statement>* "}"] "\n"
<loop>            ::= <loop-kw> "(" <condition> ") {" "\n" <statement>* "}" "\n"
<loop-kw>         ::= "while" | "for" | "forEach" | "foreach" | "loop"
<opt>             ::= "opt {" "\n" <statement>* "}" "\n"
<par>             ::= "par {" "\n" <statement>* "}" "\n"
<try-catch>       ::= "try {" "\n" <statement>* "} catch {" "\n" <statement>* ["} finally {" "\n" <statement>*] "}" "\n"

<!-- Comments -->

<comment>         ::= "// " <string> "\n"

<name>            ::= <identifier>
<method>          ::= <identifier>
<var>             ::= <identifier>
<type>            ::= <identifier>
<params>          ::= <string>
<condition>       ::= <string>
<text>            ::= <string>
<alias>           ::= <string>

<identifier>      ::= [a-zA-Z_] [a-zA-Z0-9_]*
<string>          ::= (* any sequence of characters *)
```

## Participants

Participants are rendered in order of first appearance. Declare them explicitly to control ordering.
Use aliases to display a descriptive label while referencing a short identifier in messages.

### Annotators

| Literal     | Use for                   |
| ----------- | ------------------------- |
| `@Actor`    | Human user (stick figure) |
| `@Database` | Data store (cylinder)     |
| `@Boundary` | System boundary           |
| `@Control`  | Controller or coordinator |
| `@Entity`   | Domain entity             |
| `@Queue`    | Message queue             |

## Messages

### Sync Messages

Method-call syntax (`A.method()`) represents synchronous/blocking calls. Nest statements inside `{}`
to show activation and sub-calls.

### Async Messages

Arrow syntax (`A->B: text`) represents asynchronous/fire-and-forget messages.

### Creation Messages

The `new` keyword creates a participant dynamically during the sequence.

### Reply Messages

Replies can be expressed three ways: assigning a sync call result to a variable, using `return`
inside a sync block, or annotating an async message with `@return`.

## Fragments

| Fragment    | Use for                                    |
| ----------- | ------------------------------------------ |
| `if/else`   | Alternative paths (conditional branching)  |
| `while/for` | Repeated interactions (loops)              |
| `opt`       | Optional interaction block                 |
| `par`       | Parallel execution of messages             |
| `try/catch` | Exception handling with optional `finally` |

## Comments

Line comments with `//` render above the next message or fragment. Markdown is supported in comment
text.
