---
title: 'Forgejo Actions | User guide'
license: 'CC-BY-SA-4.0'
---

`Forgejo Actions` is a Continuous Integration system built into Forgejo. It lets you automatically build, lint, test, deploy or publish your software.

## Quick start

If you want a quick way to get started with an example, check out the [quick start guide](../quick-start/).

## Workflows

Forgejo Actions workflows are defined using `.yaml` files in the `.forgejo/workflows` directory of the repository. The workflow file describes the events that should trigger the workflow, and which jobs need to be executed.

For more information about how to write workflow files, check out the [basic concepts](../basic-concepts/). There is also a guide to the more [advanced features](../advanced-features/).

## Runners

Workflows are not executed by the Forgejo instance itself. Instead, they are handed out to runners, which perform the workflow and report back with the results.

In order for a workflow to run, an appropriate runner needs to be available to the repository. You can view the available runners in the repository settings, under Actions > Runners.

If the instance does not provide runners, or if you wish to use your own runners, check out the [Forgejo Runner installation guide](../../../admin/actions/runner-installation/) to see how to set up and connect your own runner.

## Troubleshooting

Learn the basics of [troubleshooting a failed workflow or action](../troubleshooting/).

## Security

Sensitive security-related issues should be reported to [security@forgejo.org](mailto:security@forgejo.org) using [encryption](https://keyoxide.org/security@forgejo.org).

A security audit of the [runner](https://code.forgejo.org/forgejo/runner) was conducted late 2024 (see [the penetration test report](https://code.forgejo.org/forgejo/nlnet-off-ngie-forgejo/raw/commit/69f76976cc6a62bc7a64f9f76e4be75eec3d608d/target/Forgejo%20penetration%20test%20report%202024%201.0.pdf) for more information). All issues found on that occasion were fixed in 2025.

## About GitHub Actions

If you are familiar with GitHub Actions, you'll likely recognize many things in Forgejo Actions. Forgejo Actions is designed to be familiar to users of GitHub Actions, but it is **not designed to be compatible**.

If you wish to migrate a workflow from GitHub Actions to Forgejo Actions, some minimal tweaking will most likely be necessary.

For a more detailed description of the differences between GitHub Actions and Forgejo Actions, check out the [GitHub Actions differences](../github-actions/) page.

## Alternative CI options

Forgejo Actions is a CI system built into Forgejo. There are also other CI systems available, which may be more suitable for certain use-cases. A list of these is available [in the forgejo-contrib repository](https://codeberg.org/forgejo-contrib/delightful-forgejo#ci-cd).
