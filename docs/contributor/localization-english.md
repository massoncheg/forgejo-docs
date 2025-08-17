---
title: Base localization
license: 'CC-BY-SA-4.0'
---

Forgejo base localization is English. This means that all translations are derived from it.

## Managing strings

English localization strings are stored in two locations:

- `options/locale_next/locale_en-US.json` - preferred
- `options/locale/locale_en-US.ini` - legacy, doesn't support culture-specific plurals

Strings are [translated](../localization) on Weblate and string management is partially done by it.

New strings, deletion and minor edits of English strings is to be submitted in pull requests as is. All edits are considered minor unless they include changes to handling of placeholders (`%s`, `%[n]s`, `%d`, `%[n]d`).

When a new string is added, it must be double-checked that it's key is unique and is not present in transitions already.

Changes to non-base files are intended to only be done on Weblate and not by pull requests to avoid merge conflicts with Weblate PR and to not waste CI time.

When a UI change renders some string unused, it must be deleted.

Unused strings should only be deleted in base language. The string will disappear from all translations automatically after the PR is merged. Removal of invisible obsolete translated strings is either done by Weblate or sometimes manually.

When a string key needs to be changed, it must be mass-changed for all languages into which the string has already been translated, so that existing translations aren't lost. This includes merging the Weblate PR first and then re-applying the rename to avoid race conditions with changes from Weblate. It is a complicated process, so renaming keys is generally not recommended unless there's a good reason.

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
