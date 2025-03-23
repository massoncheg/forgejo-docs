---
title: Issue Search
license: 'CC-BY-SA-4.0'
---

Since v11, Issue search on Forgejo replaced it's previously dropdown defined behaviour of searches with a query syntax defined by operators.

## Query Syntax

### Keywords

1. Terms

Performs a fuzzy match search of each term in the query.

For example,

- `foo` will return results that contain `foo`, or any of it's derivatives (such as `for` or `food`)
- `foo bar` will return results that contain `foo` and/or `bar` or any of it's derivatives

2. Phrase

Performs an exact match for the provided phrase. This is done by wrapping the phrase in double quotes.

For example,

- `"foo"` will return results that contain an exact match of `foo`
- `"foo bar"` will return results that contain an exact match of `foo bar`

### Operators

1. Negation

Negates the keyword by returning results that does not contain the keyword. This is done by prefixing the keyword with a minus symbol.

For example,

- `-foo` will return results that does not contain `foo` or it's derivatives
- `-"foo bar"` will return results that does not contain `foo bar`

2. Required

Denotes that the provided keyword MUST be present. This is done by prefixing the keyword with with a plus symbol.

For example,

- `+foo +bar` will return results that contain both `foo` and `bar` (or its fuzzy derivatives)
- `+"foo" +"bar"` will return results that contain exactly both `foo` and `bar`
- `+"foo bar" +"baz"` will return results that contain exactly both `foo bar` and `baz`

### Escaping

All operators may be escaped by adding a backslash in front of the operators.

For example,

- `"\"\""` will search for `""`
- `\+1` will search for `+1`
