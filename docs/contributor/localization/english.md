---
title: English base localization
license: 'CC-BY-SA-4.0'
---

Forgejo base localization is English. This means that all translations are derived from it.

## Managing strings

English localization strings are stored in two locations:

- `options/locale_next/locale_en-US.json` - preferred
- `options/locale/locale_en-US.ini` - legacy, doesn't support culture-specific plurals

Strings are [translated](../) on Weblate and string management is partially done by it.

### Additions, deletions and minor edits

Addition of new strings, deletion of obsolete strings and minor changes should be be submitted in pull requests as is. Edits are considered minor unless they include changes to handling of placeholders (`%s`, `%[n]s`, `%d`, `%[n]d`).

```diff
+ "new-string": "Hello, world!",
//
- "obsolete-string": "This string is no longer used",
//
- "edited-string": "Remove this runner",
+ "edited-string": "Remove runner",
```

When a new string is added, it must be double-checked that it's key is unique and is not present in transitions already.

```json
"repo.pulls.poster_trust_deny": "Deny",
// <1000 other lines>
"repo.pulls.poster_trust_deny": "Deny access", // Oh, no!
```

Changes to non-base files (translations) are should only be done on Weblate and not via individual pull requests to

- prevent merge conflicts with Weblate
- not bypass of reviews on Weblate, where translation reviers know better than code reviewers
- avoid wasting CI time and cluttering PR review queue

When a UI change renders some string unused, it must be deleted.

Unused strings should only be deleted in base language. They will disappear from Weblate automatically after the PR is merged. Removal of orphaned translations from the files is done by Weblate for JSON and manually by the Localization team admins for INI components.

### Incompatible edits

String placeholders cannot be changed as is.

```json
// This change to base locale
- "initial-key": "Remove this runner?",
+ "initial-key": "Remove runner %s?",
// Breaks string rendering in all other locales
"initial-key": "Изтриване на изпълнител?",
```

If there's an intention to preserve existing translations, a migration can be prepared in coordination with the Localization team admins:

- preform the change in all locales - likely to conflict with Weblate, making it a rather complicated way
- prepare replacement that can be executed in Weblate UI if the change is possible to automate by text replacement

  For example, this change can be performed for all strings in Weblate UI avoiding conflicts with parameters:
  - filter: `initial-key`
  - search for: `%s`
  - replacement string: `%[1]s`

  ```diff
  - "initial-key": "Remove %s?",
  + "initial-key": "Remove %[1]s?",
  ```

If it is deemed fine to replace the string, the key needs to be changed:

```diff
- "initial-key": "Remove this runner?",
+ "updated-key": "Remove %[1]s?",
```

This is the easiest option for those working on the UI changes, but the translators will have to re-do their work.

### Refactoring keys

Sometime string keys are named poorly and need to be changed. In such cases they need to be mass-changed for all languages into which the strings have already been translated, so that the existing translations aren't lost. This includes merging the Weblate PR first and then re-applying the rename to avoid race conditions with changes from Weblate. It is a complicated process, so renaming keys is generally not recommended unless there's a good reason.

## Localization style

### Capitalization

All strings should have regular capitalization. Headers, labels, buttons and such should start with a capital letter. Only names, product names and such should be capitalized after that. Git/Forgejo specific measurement units should not be capitalized.

Follow these examples for string capitalization:

| Context | ❌ Bad                                 | ✅ Good                                |
| ------- | -------------------------------------- | -------------------------------------- |
| Button  | edit                                   | Edit                                   |
| Header  | Manage Organizations                   | Manage organizations                   |
| Option  | Use Custom Avatar                      | Use custom avatar                      |
| Button  | Add Cleanup Rule                       | Add cleanup rule                       |
| Label   | Integrate matrix into your repository. | Integrate Matrix into your repository. |
| Label   | %s Commits                             | %s commits                             |

### Other stylistic choices

Form labels should not end with any punctuation marks.

Follow these examples:

| Context    | ❌ Bad    | ✅ Good  |
| ---------- | --------- | -------- |
| Form label | Username. | Username |
| Form label | Username: | Username |

### Ensuring good translatability

Whenever possible, new strings should include placeholders for names and numbers they reference. Text formatting should be accessible to translators so they can make good culture-specific translations.

So instead of doing this:

```json
"commits_found": "commits were found"
```

```gotmpl
{{.NumCommits}} {{ctx.Locale.Tr "commits_found"}}.
```

Do this:

```json
"n_commits_found": {
  "one": "%d commit was found.",
  "other": "%d commits were found."
}
```

```gotmpl
{{ctx.Locale.TrPluralString .NumCommits "commits_found" .NumCommits}}
```

Large numbers can be formatted as strings like so:

```json
"n_commits_found": {
  "one": "%s commit was found.",
  "other": "%s commits were found."
}
```

```gotmpl
{{ctx.Locale.TrPluralString .NumCommits "commits_found" (CountFmt .NumCommits)}}
```

## Contributing

This section is to help you contribute to the English localization of Forgejo.

### Suggesting improvements

You send bugs, suggestions and feedback via Forgejo [issue tracker](https://codeberg.org/forgejo/forgejo/issues) or Forgejo Localization [Matrix chatroom](https://matrix.to/#/#forgejo-localization:matrix.org). Comments on Weblate also might work but are not recommended because they're checked rarely and might not be noticed.

### Proposing changes

Similarly to other projects you can propose changes via a pull request. Read the informative sections for string managing and style guidelines above. You can perform small changes via Forgejo web UI. Otherwise you can make a fork or use AGit workflow, clone, checkout a new branch, make your changes, commit, push and open a pull request. Put some useful explanation of the change in the PR description. Screenshots are also highly welcome.

If it's a small change to the string, you don't need to test it locally. However, if you want to make a larger text refactoring, consider verifying that everything looks good together in live by building and running Forgejo locally. See [For contributors](https://forgejo.org/docs/latest/contributor) for more information how to do this.

If your refactor affects key names, make sure to perform a mass-rename of the affected keys in all code, templates and translations. Sometimes keys are generated in code with conditions. Please check for that as well. With such a refactoring you might be asked to resolve merge conflicts before your PR can be merged. If you have low availability, it is best to avoid renaming translation keys.
