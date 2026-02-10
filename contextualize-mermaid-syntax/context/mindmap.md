# Mindmap

Mindmaps visually organize information into a hierarchy radiating from a central concept. Use them
for brainstorming, note-taking, or decomposing a topic into subtopics. Hierarchy is expressed
through indentation.

```bnf
<diagram>       ::= "mindmap" "\n" <node>+

<node>          ::= <indent> [<id>] <shape> ["\n" <indent> "::icon(" <icon-class> ")"] ["\n" <indent> ":::" <css-classes>]
<indent>        ::= (* whitespace determining depth; deeper indentation = child of nearest shallower node *)

<shape>         ::= <default>
                   | <square>
                   | <rounded>
                   | <circle>
                   | <bang>
                   | <cloud>
                   | <hexagon>
<default>       ::= <text>
<square>        ::= "[" <text> "]"
<rounded>       ::= "(" <text> ")"
<circle>        ::= "((" <text> "))"
<bang>          ::= "))" <text> "(("
<cloud>         ::= ")" <text> "("
<hexagon>       ::= "{{" <text> "}}"

<id>            ::= <identifier>
<icon-class>    ::= <string>
<css-classes>   ::= <identifier> [" " <identifier>]*

<identifier>    ::= [a-zA-Z_] [a-zA-Z0-9_]*
<text>          ::= <string> | <markdown-string>
<markdown-string> ::= '"`' <markdown-text> '`"'
<string>        ::= (* any sequence of characters *)
```

## Nodes

Each line defines a node. Indentation determines the parent-child relationship: a node with deeper
indentation is a child of the nearest node above it with shallower indentation. The root node is the
first node in the diagram.

### Shapes

| Literal    | Name           | Use for                                |
| ---------- | -------------- | -------------------------------------- |
| `text`     | Default        | Standard rounded rectangle             |
| `[text]`   | Square         | Structured or contained concepts       |
| `(text)`   | Rounded square | Softer, general-purpose grouping       |
| `((text))` | Circle         | Central or pivotal concepts            |
| `))text((` | Bang           | Explosive emphasis or alerts           |
| `)text(`   | Cloud          | Abstract or external concepts          |
| `{{text}}` | Hexagon        | Categorization or classification nodes |

## Icons

Icons can be attached to any node on the line immediately following it using `::icon()` syntax. The
icon class (e.g., `fa fa-book`) must reference fonts available on the hosting page.

## Classes

CSS classes can be applied to a node on the line following it using `:::` followed by
space-separated class names. These classes must be defined by the site administrator.

## Markdown Strings

Wrap text in ``"`...`"`` to enable Markdown formatting (bold, italics) and automatic text wrapping
within node labels.
