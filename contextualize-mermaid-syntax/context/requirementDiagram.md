# Requirement Diagram

Requirement diagrams visualize requirements, design elements, and their relationships following
SysML v1.6. Use them to trace how requirements are satisfied, verified, and decomposed across a
system.

```bnf
<diagram>         ::= "requirementDiagram" "\n" <statement>+

<statement>       ::= <requirement>
                    | <element>
                    | <relationship>

<requirement>     ::= <req-type> " " <name> " {" "\n" "id: " <quoted> "\n" "text: " <quoted> "\n" "risk: " <risk> "\n" "verifymethod: " <method> "\n" "}" "\n"
<req-type>        ::= "requirement" | "functionalRequirement" | "interfaceRequirement" | "performanceRequirement" | "physicalRequirement" | "designConstraint"

<element>         ::= "element " <name> " {" "\n" "type: " <quoted> "\n" ["docref: " <quoted> "\n"] "}" "\n"

<relationship>    ::= <name> " - " <rel-type> " -> " <name> "\n"
                    | <name> " <- " <rel-type> " - " <name> "\n"
<rel-type>        ::= "contains" | "copies" | "derives" | "satisfies" | "verifies" | "refines" | "traces"

<name>            ::= <identifier>
<risk>            ::= "low" | "medium" | "high"
<method>          ::= "analysis" | "inspection" | "test" | "demonstration"

<identifier>      ::= [a-zA-Z_] [a-zA-Z0-9_]*
<quoted>          ::= '"' [^"]* '"'
```

## Requirements

A requirement is the primary building block. Each requirement has a type, name, ID, descriptive
text, risk level, and verification method. The `id`, `text`, `type`, and `docref` values must be
surrounded in double quotes. Quotes cannot be escaped within the value.

### Requirement Types

| Literal                  | Use for                                       |
| ------------------------ | --------------------------------------------- |
| `requirement`            | General requirements                          |
| `functionalRequirement`  | Behavioral or functional capabilities         |
| `interfaceRequirement`   | Interface contracts between components        |
| `performanceRequirement` | Performance targets (speed, throughput, etc.) |
| `physicalRequirement`    | Physical constraints (size, weight, etc.)     |
| `designConstraint`       | Design limitations or mandated approaches     |

### Risk

| Literal  | Meaning                  |
| -------- | ------------------------ |
| `low`    | Minimal project risk     |
| `medium` | Moderate project risk    |
| `high`   | Significant project risk |

### Verification Method

| Literal         | Meaning                             |
| --------------- | ----------------------------------- |
| `analysis`      | Verified through analytical methods |
| `inspection`    | Verified through visual examination |
| `test`          | Verified through testing            |
| `demonstration` | Verified through operational demo   |

## Elements

Elements represent design artifacts (simulations, documents, test suites) that connect to
requirements. Each element has a name, type, and optional document reference.

## Relationships

Relationships connect requirements to other requirements or to elements. The arrow direction
indicates the dependency direction.

| Literal     | Use for                                            |
| ----------- | -------------------------------------------------- |
| `contains`  | Parent requirement encompasses a child requirement |
| `copies`    | One requirement duplicates another                 |
| `derives`   | Requirement is derived from another                |
| `satisfies` | Element or requirement fulfills a requirement      |
| `verifies`  | Element verifies a requirement                     |
| `refines`   | Requirement adds detail to another                 |
| `traces`    | General traceability link between requirements     |
