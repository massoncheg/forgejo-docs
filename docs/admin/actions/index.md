---
title: 'Forgejo Actions administrator guide'
license: 'CC-BY-SA-4.0'
---

`Forgejo Actions` provides continuous integration driven from the files found in the `.forgejo/workflows` directory of a
repository. Note that `Forgejo` does not run the jobs, it relies on the [`Forgejo Runner`](#forgejo-runner) to do so.

## Forgejo Runner

The `Forgejo Runner` is a program that fetches workflows to run from a Forgejo instance and executes them. It is
installed and configured separately from Forgejo.

To get started with `Forgejo Runner`:

1. Install `Forgejo Runner`
   - using a [binary installation](./installation/binary/), or
   - using a [Docker container](./installation/docker/), or
   - using [Linux distribution packaged binaries](./installation/packaging/).
2. [Register `Forgejo Runner`](./registration/) to connect it to Forgejo,
3. [Configure `Forgejo Runner`](./configuration/) to define what jobs it executes and how it operates.
   - [Choosing labels](./configuration/#choosing-labels) for the runner is the minimum required configuration.

A single `Forgejo Runner` can be connected to multiple Forgejo instances, or different users, organizations, or
repositories within a single instance. Multiple `Forgejo Runner` installations can be connected to a single Forgejo
instance to distribute jobs over a cluster of available compute resources.

`Forgejo Runner` performs remote code execution. That poses significant security threats for the host and network that
it operates upon. [Securing Forgejo Actions Deployments](./security/) walks through the security considerations and
choices that an administrator should be aware of.

To build container images in workflows or run actions that use Docker, [additional configuration](./docker-access/) is
required.

## Forgejo Settings

### Enabling/Disabling

As of `Forgejo v1.21`, Actions is enabled by default. It can be disabled by adding the following to `app.ini`:

```yaml
[actions]
ENABLED = false
```

### Default Actions URL

In a [workflow](../../user/actions/#glossary), when `uses:` does not specify an absolute URL, the
value of `DEFAULT_ACTIONS_URL` is prepended to it.

```yaml
[actions]
ENABLED = true
DEFAULT_ACTIONS_URL = https://data.forgejo.org
```

The actions published at https://data.forgejo.org are:

- known to work with Forgejo Actions
- published under a Free Software license

They can be found in organizations such as
[actions](https://data.forgejo.org/actions) for general purpose
actions, [docker](https://data.forgejo.org/docker) for those related
to Docker and so on.

When setting `DEFAULT_ACTIONS_URL` to a Forgejo instance with an open
registration, **care must be taken to avoid name conflicts**. For
instance if an action has `uses: foo/bar@main` it will clone and try
to run the action found at `DEFAULT_ACTIONS_URL/foo/bar` if it exists,
even if it provides something different than what is expected.

### Storage

The logs and artifacts are stored in `Forgejo`. The cache is stored by
the runner itself and never sent to `Forgejo`.

#### `job` logs

The logs of each `job` run is stored by the `Forgejo` server and
expire after a delay that defaults to 365 days and can be configured as
follows:

```yaml
[actions]
LOG_RETENTION_DAYS = 365
```

The location where these files are stored is configured in
the `storage.actions_log` section of `app.ini` as [explained in in the
storage documentation](../setup/storage/).

#### `artifacts` logs

The artifacts uploaded by a job are stored by the `Forgejo` server and
expire after a delay that defaults to 90 days and can be configured as
follows:

```yaml
[actions]
ARTIFACT_RETENTION_DAYS = 90
```

The location where these artifacts are stored is configured in
the `storage.artifacts` section of `app.ini` as [explained in in the
storage documentation](../setup/storage/).

The `admin/monitor/cron` administration web interface can be used to
manually trigger the `Cleanup actions expired logs and artifacts` task
instead of waiting for the scheduled task to happen.

## Other runners

It is possible to use [other runners](https://codeberg.org/forgejo-contrib/delightful-forgejo#user-content-forgejo-actions-runners) instead of `Forgejo Runner`. As long as they can connect to a Forgejo instance using the [same protocol](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/routers/api/actions), they will be given tasks to run.
