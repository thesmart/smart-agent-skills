# Endpoint Badge

The endpoint badge delegates rendering to a custom JSON API. Shields.io fetches the endpoint and
generates the badge from the response.

```bnf
<endpoint-url> ::= "https://img.shields.io/endpoint?url=" <encoded-json-url> <query-params>?
<query-params> ::= "&" <param> ("&" <param>)*
<param>        ::= <override-param> | <display-param>
```

## Endpoint JSON Response Schema

The endpoint must return `Content-Type: application/json` with this structure:

| Property        | Required | Default     | Description                                                 |
| --------------- | -------- | ----------- | ----------------------------------------------------------- |
| `schemaVersion` | yes      | --          | Must be `1`                                                 |
| `label`         | yes      | --          | Left-side text; empty string `""` omits the left side       |
| `message`       | yes      | --          | Right-side text; cannot be empty                            |
| `color`         | no       | `lightgrey` | Right background color                                      |
| `labelColor`    | no       | `grey`      | Left background color                                       |
| `isError`       | no       | `false`     | If `true`, prevents query string color override             |
| `namedLogo`     | no       | --          | Simple-icons slug from simpleicons.org                      |
| `logoSvg`       | no       | --          | Custom SVG string for logo                                  |
| `logoColor`     | no       | --          | Logo tint color                                             |
| `logoSize`      | no       | --          | Set `"auto"` for adaptive sizing                            |
| `style`         | no       | `flat`      | `flat`, `flat-square`, `plastic`, `for-the-badge`, `social` |
