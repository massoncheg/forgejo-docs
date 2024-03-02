---
title: Semantic Version
license: 'CC-BY-SA-4.0'
---

[SemVer](https://semver.org/spec/v2.0.0.html) allows users to understand the scope of a software update at first glance, based on the following:

- `<MAJOR>` is increased for breaking changes.
- `<MINOR>` is increased for backwards-compatible new features.
- `<PATCH>` is increased for backwards-compatible bug fixes.

Changes could be:

- a command, an option or an argument, for a CLI
- a route path, a query parameter or a body property, for a REST API
- a text node, a button or a field, for a GUI

Since Forgejo has all of the above, changes to all of those components should be taken into consideration when creating a new version number.

## Understanding the Forgejo stable semantic version

The structure of the version number is `<MAJOR>.<MINOR>.<PATCH>+gitea-<GITEA VERSION>`, where:

- `<MAJOR>.<MINOR>.<PATCH>` is conformant to [Semantic Versioning 2.0.0](https://semver.org/#semantic-versioning-200)
- `gitea-<GITEA VERSION>` is the Gitea version this Forgejo release is compatible with

## Understanding the Forgejo pre-release semantic version

The structure of the version number is `<MAJOR>.<MINOR>.<PATCH>-<PRE-RELEASE>+gitea-<GITEA VERSION>`, where:

- `<MAJOR>.<MINOR>.<PATCH>` is conformant to [Semantic Versioning 2.0.0](https://semver.org/#semantic-versioning-200)
- `<PRE-RELEASE>` is the pre-release version, such as a release candidate (`RC`)
- `gitea-<GITEA VERSION>` is the Gitea version this Forgejo release is compatible with

## Getting the Forgejo semantic version

As of Forgejo v1.19, there are two version numbering schemes:

- [Following the Gitea version](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/CONTRIBUTING/RELEASE.md#release-numbering) which is not a semantic version
  - Used to name release files
  - Used for tagging releases
  - Displayed in the web interface
  - Returned by the `/api/v1/version` API endpoint
- Forgejo semantic version
  - Returned by the `/api/forgejo/v1/version` API endpoint

For instance, the semantic version for https://code.forgejo.org can be obtained with:

```shell
$ curl https://code.forgejo.org/api/forgejo/v1/version
{"version":"3.0.0+0-gitea-1.19.0"}
```
