---
name: code-shields-io
description: "Activate when the user asks to create, edit, or add badges to a repository README or markdown file using shields.io. Triggers include: badge, shield, README, version badge, license badge, shields.io."
argument-hint: [badge-description]
license: MIT
compatibility: Designed for Claude Code (and compatible)
metadata:
    author: thesmart
    version: "1.0"
---

# Shields.io Badge Generator

You generate shields.io badge URLs for embedding in markdown files (READMEs, docs, etc.).

## Badge URL Syntax

All badges are SVGs served from `https://img.shields.io/`.

### Static Badge

```bnf
<static-url>   ::= "https://img.shields.io/badge/" <badge-content> <query-string>?
<badge-content> ::= <label> "-" <message> "-" <color>
                   | <message> "-" <color>
```

### Dynamic Badge

Fetches a value from a remote document and displays it.

```bnf
<dynamic-url> ::= "https://img.shields.io/badge/dynamic/" <format>
                   "?url=" <encoded-url> "&query=" <encoded-query> <query-string>?
<format>      ::= "json" | "xml" | "yaml" | "toml"
```

- `json`, `yaml`, `toml`: use JSONPath for `query` -- see [JSONPath syntax](./context/jsonpath.md)
- `xml`: use XPath for `query` -- see [XPath syntax](./context/xpath.md)

Extra params: `prefix`, `suffix` (text around the extracted value).

### Endpoint Badge

Delegates badge rendering to a custom JSON endpoint -- see
[endpoint schema & params](./context/endpoint.md).

```bnf
<endpoint-url> ::= "https://img.shields.io/endpoint?url=" <encoded-json-url> <query-string>?
```

## Query Parameters

Query string parameters override the corresponding endpoint response values (except when `isError`
is `true`, which prevents `color` override).

Append to any badge URL as `?key=value&key=value`.

| Param          | Values                                                                | Effect                                       |
| -------------- | --------------------------------------------------------------------- | -------------------------------------------- |
| `style`        | `flat` (default), `flat-square`, `plastic`, `for-the-badge`, `social` | Badge shape                                  |
| `logo`         | simple-icons slug (see [simpleicons.org](https://simpleicons.org))    | Left-side icon                               |
| `logoColor`    | color                                                                 | Icon tint                                    |
| `logoSize`     | `auto`                                                                | Adaptive icon sizing                         |
| `label`        | string                                                                | Override left text                           |
| `labelColor`   | color                                                                 | Left background                              |
| `color`        | color                                                                 | Right background                             |
| `cacheSeconds` | number                                                                | Cache lifetime                               |
| `link`         | URL (repeatable)                                                      | Click targets (only works in `<object>` tag) |

## Colors

Supports:

- Hex colors: `[0-9a-fA-F]{3,8}`
- CSS colors: `rgb(...)`, `rgba(...)`, `hsl(...)`, `hsla(...)`.
- English named colors: `brightgreen`, `green`, `yellow`, `yellowgreen`, `orange`, `red`,
  `blue`, `grey`, `lightgrey`, `blueviolet`, `success`, `important`, `critical`, `informational`,
  `inactive`.

## URL Encoding

All path segments and query parameter values must be percent-encoded.

**Path encoding rules:**

| Input        | Renders as |
| ------------ | ---------- |
| `_` or `%20` | space      |
| `__`         | `_`        |
| `--`         | `-`        |

Percent-encode special characters (`%25` for `%`, `%2F` for `/`, etc.).

You may use [`urlencode.sh`](./urlencode.sh) to encode values:

```sh
./urlencode.sh "my value"              # argument
echo "my value" | ./urlencode.sh       # stdin
```

## Markdown Embedding

```markdown
![alt text](https://img.shields.io/badge/label-message-color)

<!-- With link -->

[![alt text](https://img.shields.io/badge/label-message-color)](https://target-url)
```

## Instructions

1. Ask or infer (based on language conventions) what badges the user needs (build status, code coverage, version, license, etc.).
2. For each badge, determine:
    - **Type**: static, dynamic, or endpoint
    - **Label** (left text) and **message** (right text)
    - **Color** appropriate to meaning (green=passing, red=failing, blue=info, etc.)
    - **Logo** if relevant (match the service name to a [simple-icons](https://simpleicons.org) slug)
    - **Style** -- default to `flat` unless user specifies otherwise
3. Construct the URL using the syntax above. Encode path segments properly.
4. Output as markdown image syntax, wrapped in a link if a target URL is appropriate.
5. If adding to an existing file, place badges at the top of the document (after the `# title`), one
   per line or grouped on a single line separated by spaces.

## Dependencies

None -- badges are rendered by shields.io; no local tools required.
