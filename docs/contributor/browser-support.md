---
title: Web browser support
license: 'CC-BY-SA-4.0'
---

## Feature recency

New and existing Forgejo web UI features that affect usability of Forgejo should rely on browser features and APIs available in **both**:

- Latest version of Firefox ESR
- Previous major version of Chromium

For example, [forgejo/forgejo#8859](https://codeberg.org/forgejo/forgejo/pulls/8859#issuecomment-6808852) couldn't rely on the new [`closedBy`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLDialogElement/closedBy) property of `HTMLDialogElement` because it was re-implementing an existing significant feature (modal dialogs) and `closedBy` was not yet supported by Firefox ESR. So not implementing a [compatible JS function](https://codeberg.org/forgejo/forgejo/src/commit/aa345c9e0cb8809844112ad929ac1acbd59817d6/web_src/js/modules/modal.ts#L22-L33) would break the ability of users to close the dialog by clicking outside of it on a supported browser, which would have been considered a newly introduced bug in Forgejo v13.0.0.

The latest Firefox ESR version can be calculated differently:

- If pull request is proposed to be backported to stable branch of Forgejo, the latest Firefox ESR as of present day should be considered
- If pull request targets the next major Forgejo release, the latest Firefox ESR as of the day of that Forgejo release should be considered. Refer to [Forgejo release schedule](https://forgejo.org/docs/next/admin/release-schedule/) and [Firefox release calendar](https://whattrainisitnow.com/calendar/) to find the matching ESR version

New features that do not affect usability can rely on browser features up to [Baseline of last year](https://web.dev/baseline) is acceptable.

## Feature oldness and non-standard features

It's up to the contributor to work on additional support beyond the minimally required platforms as long as such compatibility doesn't introduce:

- Significant increase in complexity
- Additional dependencies (e.g. compatibility libraries)

However we do not welcome additional code that only exists to maintain compatibility with browser engines that have been completely officially discontinued, such as:

- MSHTML (Microsoft Internet Explorer)
- EdgeHTML (Microsoft Edge)
- Presto (Opera)
- KHTML

[Vendor prefixes](https://developer.mozilla.org/en-US/docs/Glossary/Vendor_Prefix) should be used strictly when necessarily. When a property is supported without vendor prefixes on the minimally required platforms, vendor-prefixed properties should not be used.
