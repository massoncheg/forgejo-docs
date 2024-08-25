---
title: 'Testing'
license: 'CC-BY-SA-4.0'
---

A [reasonable effort should be made to test changes](https://codeberg.org/forgejo/governance/src/branch/main/PullRequestsAgreement.md)
proposed to Forgejo.

## Running the tests from sources

To run automated frontend and backend tests:

```bash
make test
```

## Frontend tests

See [the e2e README](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/tests/e2e/README.md).

## Interactive testing

To run and continuously rebuild when the source files change:

```bash
TAGS='sqlite sqlite_unlock_notify' make watch
```

> **NOTE:** do not set the `bindata` tag such as in `TAGS="bindata" make watch` or the browser may fail to load pages with an error like `Failed to load asset`

## Manual run of the binary

After following the [steps to compile from source](../from-source/), a `forgejo` binary will be available
in the working directory.
It can be tested from this directory or moved to a directory with test data. When Forgejo is
launched manually from command line, it can be killed by pressing `Ctrl + C`.

```bash
./forgejo web
```

## Automated tests

### In the Forgejo repository

When a [pull request](https://codeberg.org/forgejo/forgejo/pulls) is opened,
it will run workflows found in the [.forgejo/workflows](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/.forgejo/workflows)
directory.

### In the end-to-end repository

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

When the change to be tested lacks the proper framework, the manual
test steps must be documented in the description of the pull request.

Changes that are associated with manual tests must be labeled
labeled ["test/manual"](https://codeberg.org/forgejo/forgejo/issues?labels=201028).
