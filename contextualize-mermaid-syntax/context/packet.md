# Packet Diagram

Packet diagrams visualize the structure and layout of network packets, showing how bits are
allocated to fields. Use them to document protocol headers, binary formats, or any fixed-width data
structure where bit positions matter.

```bnf
<diagram>       ::= "packet-beta" "\n" <field>+

<field>         ::= <bit-range> ': "' <label> '"' "\n"

<bit-range>     ::= <start>
                   | <start> "-" <end>
<start>         ::= <non-negative-integer>
<end>           ::= <non-negative-integer>

<label>         ::= <string>

<non-negative-integer> ::= [0-9]+
<string>        ::= (* any sequence of characters excluding double quotes *)
```

## Fields

Each line after the header defines a field in the packet. Fields are specified by bit position and a
quoted description.

### Bit Ranges

| Syntax | Use for                                          |
| ------ | ------------------------------------------------ |
| `N`    | A single-bit field at position N                 |
| `N-M`  | A multi-bit field spanning positions N through M |

Bit positions are zero-indexed. Fields are rendered row by row (default 32 bits per row).

## Title

A title can be set via frontmatter YAML or inline `title` keyword before the field definitions.
