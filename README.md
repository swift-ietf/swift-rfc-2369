# swift-rfc-2369

Use this package when you add or read the RFC 2369 mailing list header fields of an email: `List-Help`, `List-Unsubscribe`, `List-Subscribe`, `List-Post`, `List-Owner` and `List-Archive`. Start from `RFC_2369.List.Header`, and use `RFC_2369.List.Post` for the `List-Post` value on its own. For one-click unsubscribe with `List-Unsubscribe-Post`, use swift-rfc-8058.

## Laws

- Every URI is written inside angle brackets, and several URIs in one field are joined with a comma and a space. A list that is nil or empty writes no field.
- `RFC_2369.List.Post.noPosting` is written as `NO`, and parsing accepts `NO` in any case.
- Parsing a `List-Post` value skips comments in parentheses, nested ones too, except inside angle brackets. It fails when nothing is left, or when no URI in angle brackets remains. URIs keep their order.
- Parsing header text matches field names ignoring case and ignores other fields. A line that starts with a space or tab continues the field before it, unless an empty line comes between them.
- Parsing header text never fails on a bad value. A URI that isn't a valid IRI is left out, a `List-Post` value that doesn't parse leaves `post` nil, and `List-Help` and `List-Archive` keep only their first URI.
