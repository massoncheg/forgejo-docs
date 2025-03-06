---
title: Localization
license: 'CC-BY-SA-4.0'
---

Forgejo is translated via Weblate, a libre web-based translation platform.

## Translating via Weblate

The Forgejo project's localization project is publicly available via the [Codeberg Translate](https://translate.codeberg.org/projects/forgejo/forgejo/) Weblate instance.

### Translation guidelines

1. Only suggest changes that benefit all users of the translation. Please do not suggest changes that will only make the translation better in cases specific to any self-hosted Forgejo instance. Instead customize such instances separately from Forgejo upstream.
2. Keep the translation as beginner-friendly as possible.
3. Users are not obligated to complete any translation. When unsure about the translation, feel free to leave it for others to translate.

### Discovering the translation

Go to the [Project](https://translate.codeberg.org/projects/forgejo/forgejo/) page for a list of languages that are currently available for translation.

From the language page it is possible to browse all translation strings, as well as untranslated, unfinished and failing translations.

### Suggesting changes

Anonymous suggestions for changes and additions to the existing translation can be submitted by finding the string for which to suggest a change, typing the change in, and then clicking "Suggest".

All suggested change will be checked before being accepted. Since most localization members are likewise volunteers, this can take a while.

### Making direct changes, accepting suggestions

Direct changes require a [Codeberg](https://codeberg.org/) account which can be used to access the [Codeberg Translate](https://translate.codeberg.org/) account.

If the translation is not approved it is possible to edit the string again and use the "Save" button to save the change. Existing suggestions can either be applied, or rejected by optionally specifying the rejection reason.

Once the string is translated and approved it can only be changed by a Forgejo **Localization Team** member, though everyone else is still able suggest changes.

To protect the existing translations from vandalism, all strings imported from Gitea were automatically marked as approved.

### Adding a new language

If your language is not available in the language list it must be added first before translating.

To add a new language, go to the [page for starting new translation](https://translate.codeberg.org/new-lang/forgejo/forgejo/), select a language and click "Start new translation".

### E-mail privacy

By default, Weblate will use your primary e-mail address for all contributions. If you want to adjust this behavior, go to [Weblate settings - Account](https://translate.codeberg.org/accounts/profile/#account) and select a different e-mail under the "Commit e-mail" section. Select a `noreply` address to avoid using a real one.

## Tips

You can see the current translations in live on a dev instance: https://dev.next.forgejo.org. Usually strings would lag behind Weblate up to 9 days here, but it's good enough for a quick overview.

### Finding strings

To locate a string on Weblate quickly, you can open a page including the string, append `?lang=dummy` query parameter to URL (if there is already a `?`, append `&lang=dummy` to it), and all strings will be replaced with their keys.

When searching on Weblate, the first part of keys ("section") may need to be wrapped with `[]`. For example, on Weblate, `settings.enable_custom_avatar` should be searched with `[settings]enable_custom_avatar`, `issues` -> `[common]issues`, and `filter.public` -> `[common]filter.public`. If you are getting no results, wrap the section and search again.

## Discussing the translation

To ask questions, clarify string meaning, report vandalism or suggest changes to source strings post in [Matrix room](https://matrix.to/#/#forgejo-localization:matrix.org) or [issues](https://codeberg.org/forgejo/forgejo/issues). Doing this is not restricted to members of the **Localization Team**.

## Joining the Localization Team

Any [Codeberg Translate](https://translate.codeberg.org) user is able to suggest translations, translate new strings, add comments and discuss existing translations with our **Localization Team**.

If you would like to maintain the translation, join the **Localization Team** as a member by sending us an application.

However, before doing that, we recommend working on translations independently before applying. This allows time to get used to the workflow and collaborating within the **Localization Team**. Members are able to accept their own suggestions.

### Applying

In order to become a member of the team apply by opening a new issue at [forgejo/governance](https://codeberg.org/forgejo/governance) repository. See [previous applications](https://codeberg.org/forgejo/governance/issues?q=application+to+the+localization+team&state=closed) for inspiration.

In the application message, state the following:

- Motivation for becoming a member.
- Experience translating other projects and using Weblate. E.g. link(s) to public translation profile(s) or contribution(s).

The application process will take approximately two (2) weeks (or more) to complete.

### Responsibilities

Becoming a part of any of our team comes with a couple of responsibilities:

- Members must act in accordance to the [Code of Conduct](https://codeberg.org/forgejo/code-of-conduct).
- Members must act in accordance to all other rules and process that Forgejo agrees on through [its decision making process](https://codeberg.org/forgejo-contrib/governance/src/branch/main/DECISION-MAKING.md).

Translations should aim to target people of different backgrounds across all reasonable end user locales.

Since text is highly subjective, this is simply a goal that should be striven for and not a measurable requirement. Remain receptive to creative feedback from the **Localization Team** members.

## Troubleshooting

When having problems using Weblate, there are multiple support channels available:

- [Weblate documentation](https://docs.weblate.org)
- [Weblate issues](https://github.com/WeblateOrg/weblate/issues)
- [Codeberg Translate chat room](https://matrix.to/#/#codeberg-translate:bubu1.eu)
- [Codeberg community issues](https://codeberg.org/Codeberg/Community/issues)
