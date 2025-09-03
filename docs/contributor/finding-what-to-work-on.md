---
title: Finding what to work on in Forgejo
license: 'CC-BY-SA-4.0'
---

Assuming that your [development environment is ready][] and that you are aware of how you can reach out to the Forgejo community, this document shall describe how you can find [Forgejo][] issues to work on.

[development environment is ready]: ../development-environment/
[Forgejo]: https://codeberg.org/forgejo/forgejo

## `good-first-issue` label

Issues are marked using _labels_. The `good-first-issue` label is used to explicitly mark issues that may be appealing to potential new first time contributors. Content-wise, the issues can vary significantly, as they can range between simple fixes to user-facing strings, to features that primarily involve backend development or web development.

As such, do keep in mind that `good-first-issue` does not necessarily imply that fixing them will be easy or quick. Also, there is a possibility that an issue that you may choose may get too time-consuming. If that happens, don't fret! First, this is completely normal when trying to learn your way around a new free and open-source project. Second, you can always ask other contributors for help if you feel lost (and you should!). In the worst case, you will have learned a few things as a direct result of having been exposed to actual source code. Also, you can always choose to pick another issue, and circle back to the more difficult issue at a later point in time.

[Click here][good-first-issue] to discover issues labelled using the `good-first-issue` label.

[good-first-issue]: https://codeberg.org/forgejo/forgejo/issues?q=&type=all&state=open&labels=222666

## `valuable code` label

As most Forgejo contributors are volunteers, authors might not have the time to address review comments for their submitted pull request. "Work in progress" pull requests that have had unaddressed review comments for a longer period of time get closed, as it helps reviewers avoid checking whether any progress has been made repeatedly since their last review.

However, that does not mean that the features in the pull requests themselves are unwanted: More often than not, the pull requests are closed because of unaddressed review comments (which are sometimes easy to fix) or because of missing tests. The `valuable-code` is applied to such pull requests to ensure that they do not get lost. This label also intends to signal that there is a desire to have pull requests merged.

The `valuable code` way could be better tasked to people that have contributed to free and open-source projects before, and has the additional upside of helping you get acquainted with Forgejo's internals and review processes _without_ having to learn everything at once (UI, backend, tests, [documentation requirements][] submitting the PR). Before picking up on such tasks, we suggest pinging the original author to make sure that you would not be working on the same tasks simultaneously, yet separately.

[documentation requirements]: https://codeberg.org/forgejo/discussions/issues/213

[Click here][closed-valuable-code] to navigate _closed_ pull requests with the valuable code label.

[closed-valuable-code]: https://codeberg.org/forgejo/forgejo/pulls?q=&type=all&sort=&state=closed&labels=217340

## Bug fixes

Another way of contributing to Forgejo is fixing confirmed bugs. Helping us improve Forgejo's stability and reliability is something that we can always use help with, and such efforts are [immensely appreciated and prioritized by the reviewers][pr-priorities]. Fixing bugs is a great way to get acquainted with Forgejo's different components and development procedures _without_ exposing yourself to a lot of complexity.

[pr-priorities]: https://codeberg.org/forgejo/discussions/issues/337

[Click here][bug-confirmed] to navigate _confirmed_ bug reports.

In this context, _confirmed_ means that an individual (other than the bug reporter) has managed to reproduce the bug described by the reporter. You can also help us with [new bug reports][bug-new-report] by attempting to reproduce the bugs yourself.

[bug-confirmed]: https://codeberg.org/forgejo/forgejo/issues?q=&type=all&state=open&labels=201023
[bug-new-report]: https://codeberg.org/forgejo/forgejo/issues?q=&type=all&sort=&labels=201022

## Documentation

Administrators, (prospective) contributors and users of Forgejo all share one characteristic: Sooner or later, they will (most likely) have to rely on our documentation.

Improvements to our documentation help everyone involved, and it is unlikely that you will have to touch any code. Should you notice any inaccuracies or topics which are not covered by our documentation, then we encourage you to try authoring a Pull Request. You can also try working on issues that were opened by other community members.

[Click here][forgejo-docs-issues] to view issues available in the [`forgejo/docs`][forgejo-docs] repository.

[forgejo-docs-issues]: https://codeberg.org/forgejo/docs/issues
[forgejo-docs]: https://codeberg.org/forgejo/docs/

## Further notes

- There exist [many other Forgejo-related projects that one can contribute to][forgejo-profile].
- The [Pull Requests Agreement][pr-agreement] lists the conditions for merging Pull Requests in Forgejo repositories.
- Forgejo contributions are subjected to [testing requirements][]. Feel free to ask other contributors for help.

[forgejo-profile]: https://codeberg.org/forgejo/.profile
[pr-agreement]: https://codeberg.org/forgejo/governance/src/branch/main/PullRequestsAgreement.md
[testing requirements]: ../testing/
