---
title: Issue Search
license: 'CC-BY-SA-4.0'
---

Since v11, Issue search on Forgejo replaced its previously dropdown-defined behavior of searches with a query syntax defined by operators.

## Query Syntax

### Keywords

1. Terms

Performs a fuzzy match search of each term in the query.

For example,

- `foo` will return results that contain `foo`, or any of its derivatives (such as `for` or `food`)
- `foo bar` will return results that contain `foo` and/or `bar` or any of their derivatives

2. Phrase

Performs an exact match for the provided phrase. This is done by wrapping the phrase in double quotes.

For example,

- `"foo"` will return results that contain an exact match of `foo`
- `"foo bar"` will return results that contain an exact match of `foo bar`

### Operators

1. Negation

Negates the keyword by returning results that do not contain the keyword. This is done by prefixing the keyword with a minus symbol.

For example,

- `-foo` will return results that do not contain `foo` or its derivatives
- `-"foo bar"` will return results that do not contain `foo bar`

2. Required

Denotes that the provided keyword MUST be present. This is done by prefixing the keyword with a plus symbol.

For example,

- `+foo +bar` will return results that contain both `foo` and `bar` (or its fuzzy derivatives)
- `+"foo" +"bar"` will return results that contain exactly both `foo` and `bar`
- `+"foo bar" +"baz"` will return results that contain exactly both `foo bar` and `baz`

### Escaping

All operators may be escaped by adding a backslash in front of the operators.

For example,

- `"\"\""` will search for `""`
- `\+1` will search for `+1`

## Filters

Filters listed below may be escaped by using a phrase search. For example, `"is:open"`.

### State

These filters are mutually exclusive.
If multiple state filters are used, then the rightmost filter takes precedence.

|          Filter           |                         Description                         |
| :-----------------------: | :---------------------------------------------------------: |
| `is:open` or `-is:closed` |         Filters issues/pull requests that are open          |
| `is:closed` or `-is:open` |        Filters issues/pull requests that are closed         |
|         `is:all`          | Filters issues/pull requests that are either open or closed |

Examples,

- `is:open +"bug"`: Searches for `bug` among open issues/PRs.
- `is:all -"backport"`: Search for all issues/PRs that do not contain the term "backport".
- `"is:all"`: Literal search for `is:all`. Matches Issues/PRs that contain the term `is:all`.

### User

These filter issues/pull requests by a username.

|    Filter    |    Description    |
| :----------: | :---------------: |
|  `author:*`  |    Authored By    |
| `assignee:*` |    Assigned To    |
|  `review:*`  |    Reviewed By    |
| `mentions:*` | Mentions the user |

Examples,

- `author:forgejo is:all`: All issues/PRs created by user `forgejo`.

### Misc.

|         Filter         |                                      Description                                       |
| :--------------------: | :------------------------------------------------------------------------------------: |
| `sort:<by>:[asc/desc]` | Sorts issues/PRs. Where, `<by>` is one of `created`, `comments`, `updated`, `deadline` |
| `modified:[>/<]<date>` |                            Last updated date in ISO format                             |

Examples,

- `sort:created:desc is:all`: Sort by the latest issues/PRs.
- `sort:comments:desc`: Sort by the most commented issues.
- `modified:>2025-12-05`: Searches for issues/PRs modified after `2025-12-05`.
- `modified:2025-12-05`: Searches for issues/PRs modified exactly on `2025-12-05`.
- `modified:<2025-12-05`: Searches for issues/PRs modified before `2025-12-05`.
