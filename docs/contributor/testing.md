---
title: 'Testing'
license: 'CC-BY-SA-4.0'
---

If you want to contribute to Forgejo,
keep in mind that we ask you to do a
[reasonable effort to test your changes](https://codeberg.org/forgejo/governance/src/branch/main/PullRequestsAgreement.md).

Why would we do this?
Your submission to Forgejo could be wasted if you add it,
but no one checks that it still works in a few months, or a few years.
We want your contribution to be meaningful and to last.

We cannot test all the behaviour of Forgejo.
It is complex, and certain aspects are only important to a handful of users.
To reduce the burden on maintainer,
you should do your best to make testing easy and automated.

## What is a "reasonable" effort?

There is no simple answer to this,
but we want to see that you gave your best.
It will be decided on a case-by-case basis by the maintainers.

Some changes are easy to write a test for.
Other tests can be really hard and challenging.
This guide tries to provide you some starting points,
and if you don't know how to continue,
please submit your contribution and ask for help in writing a test.
We will happily assist you.

## How to write a good test?

Let's list some basic things when writing software tests.
Creating _good tests_ can be a creative challenge,
and you'll benefit from experience
(both from writing tests and working with the Forgejo codebase).

These basic rules should hopefully guide you the way.

### Test the actual change

Some parts of the codebase don't bring extensive testing yet.
Asking you to cover all the behaviour with tests would often be too much.
If in doubt, try to focus on the change you made:

- Which behaviour did you change?
- Can you demonstrate that something works differently?
- Can you write a test that fails before,
  and passes after your actual contribution?

Take a look at [this example](https://codeberg.org/forgejo/forgejo/pulls/5110/files#diff-f1c02e9204a32c192cc594c01dfb737e14bc4601).
It tests a very simple change in diff generation.
It does not add tests for all the (edge) cases of diff generation,
but it provides a simple verification that the diff is generated on larger words,
not letter-by-letter,
by adding samples that are affected by the change.

### Test the edge cases

If you test different input, consider the behaviour at edge cases.
For example, what happens with an empty string?
If you want to test a size limitation,
do not only test content that is "way too large",
also test content that is a perfect fit,
and the first content size that should be rejected.

### Get inspiration or help

Please don't hesitate to reach out for help or ask for feedback.
In some cases, good knowledge of the codebase is helpful
(e.g. to think of testing your feature's compatibility with another feature you never heard of).

We recommend that you take inspiration from existing tests.
Take a look at the Git history around your files
(or the kind of tests such as e2e/integration)
to see who made recent changes.
They have high chances of being more idiomatic and modern than the average test code,
and feel free to ping people directly for help.

## Getting Started

There are three kinds of tests in Forgejo.

### Unit tests

These live next to the code in files suffixed
`_test.go` (for backend code)
or `.test.js` (for frontend code).

They test small portions of the code,
mostly functions that process data and have no side-effects.
Use these where possible.

Run these with:

```bash
make test
```

### Integration tests

Find these in `tests/integration`.
They test more complex behaviour of the app
(such as performing an action and seeing that related activity is recorded).
They are mostly useful when a behaviour is hard to test with isolated unit tests.

There is more detailed information in the
[integration test README](https://codeberg.org/forgejo/forgejo/src/tests/integration/README.md).

### End-to-end / browser tests

Find these in `tests/e2e`.
They run real browsers and test the frontend of Forgejo.
Use them to verify that things look like they should,
or that pressing a specific button does what it is supposed to do.
You can also run an automated accessibility analysis.

There is more detailed information in the
[e2e test README](https://codeberg.org/forgejo/forgejo/src/tests/e2e/README.md).

## Interactive testing during development

During development, you'll probably want to interact with Forgejo to see if your changes work.

To run and continuously rebuild when the source files change:

```bash
TAGS='sqlite sqlite_unlock_notify' make watch
```

> **NOTE:**  
> Do not set the `bindata` tag such as in `TAGS="bindata" make watch`.
> The browser may fail to load pages with an error like `Failed to load asset`.

## Automated tests

### In the Forgejo repository

When a [pull request](https://codeberg.org/forgejo/forgejo/pulls) is opened,
it will run workflows found in the [.forgejo/workflows](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/.forgejo/workflows)
directory.

### In the end-to-end repository

> **Note:**  
> Do not confuse this kind of testing with the "e2e" (frontend) tests in the Forgejo repository.

Some tests are best served by running Forgejo from a compiled binary,
for instance to verify the result of a workflow run by the [Forgejo runner](https://code.forgejo.org/forgejo/runner). They can be
run by adding the `run-end-to-end-test` label to the pull request. It will:

- compile a binary from the pull request
- open a pull request against the [end-to-end](https://code.forgejo.org/forgejo/end-to-end) repository
- use the compiled binary to run the tests
- report back failure or success

### Debugging locally

A workflow can be run locally by [installing the Forgejo runner](../../admin/actions/#installation) and using the command line:

```sh
forgejo-runner exec --workflows .forgejo/workflows/testing.yml
```

## Manual testing

When the change to be tested lacks the proper framework,
we sometimes add manual testing instructions as a last resort.
The exact test steps must be documented in the description of the pull request.

Changes that are associated with manual tests must be labeled
["test/manual"](https://codeberg.org/forgejo/forgejo/issues?labels=201028).
