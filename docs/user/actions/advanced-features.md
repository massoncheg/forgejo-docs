---
title: Forgejo Actions | Advanced features
license: 'CC-BY-SA-4.0'
---

This page covers the more advanced features of Forgejo Actions.

## Artifacts

`Artifacts` let you persist data after a job has completed. An artifact is a file or collection of files produced during a workflow run.

This has two main uses:

- Storing non-permanent data after a workflow finishes, like test results.
- Storing data generated in one job, so another job later in the same workflow can use it.

Artifacts expire after a delay of 90 days by default, but this may be changed by the instance admin.

The artifacts created by a workflow can be downloaded from the web
interface that shows the the details of the jobs for a workflow.

![download artifacts](../../_images/user/actions/actions-download-artifact.png)

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-artifacts/.forgejo/workflows)
based on the [upload-artifact](https://code.forgejo.org/actions/upload-artifact) action and
the [download-artifact](https://code.forgejo.org/actions/download-artifact) action.

## Uploading to a package registry

Forgejo offers built-in [package registries](../../packages/). You can use these to publish packages for various package managers, or just [generic](../../packages/generic) build output.

## Cache

You can use the `Cache` to reuse commonly used files from previous workflow runs, like package downloads or intermediary build results.

Some Actions will automatically use the cache. For
instance the [setup-go](https://code.forgejo.org/actions/setup-go) action will do that by default to save downloading and compiling packages found in `go.mod`.

It is also possible to explicitly control what is cached (and when)
by using the [actions/cache](https://code.forgejo.org/actions/cache) action.
Caching makes no guarantees that a cache will be populated, even when two
`jobs` are run in sequence. If you want to reliably exchange information
between `jobs`, see [`artifacts`](#artifacts).

See also the [set of examples](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-cache/.forgejo/workflows/).

> **NOTE:** [actions/cache](https://code.forgejo.org/actions/cache) will use `zstd` if present when compressing files to be sent to the cache. It is faster than the default compression. A container which does not have `zstd` installed _will not_ be able to decompress the cache and will continue without. In general it is recommended to ensure that if you're using `zstd` in one place in your project, you use it everywhere.

> **NOTE:** if the runner is not configured to provide a cache, [actions/cache](https://code.forgejo.org/actions/cache) will fail with the following error: `Cache action is only supported on GHES version >= 3.5`.

## Services

PostgreSQL, Redis and other services can be run from container images with something similar to the following. See also the [set of examples](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-service/.forgejo/workflows/).

```yaml
job:
  my-job:
    runs-on: docker
    services:
      pgsql:
        image: postgres:15
        env:
          POSTGRES_DB: test
          POSTGRES_PASSWORD: postgres
    ...
```

A container with the specified `image:` is run before the job starts and is terminated when it completes. The job can address the service using its name, in this case `pgsql`.

The IP address of `pgsql` is on the same [network](https://docs.docker.com/engine/reference/commandline/network/) as the container running the **steps** and there is no need for port binding. The `postgres:15` image exposes the PostgreSQL port 5432 and a client will be able to connect as [shown in this example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-service/.forgejo/workflows/test.yml)

### image

The location of the container image to run.

### env

Key/value pairs injected in the environment when running the container, equivalent to [--env](https://docs.docker.com/engine/reference/commandline/run/).

### cmd

A list of command and arguments, equivalent to [[COMMAND] [ARG...]](https://docs.docker.com/engine/reference/commandline/run/).

### options

A string of the following additional options, as documented [docker run](https://docs.docker.com/engine/reference/commandline/run/).

- `--volume`
- `--tmpfs`
- `--hostname` (except for Forgejo runner 6.0.x and 6.1.x)

> **NOTE:** the `--volume` option is restricted to a allowlist of volumes configured in the runner executing the task. See the [Forgejo runner installation guide](../../admin/runner-installation/#configuration) for more information.

### username

The username to authenticate with the registry where the image is located.

### password

The password or access token to authenticate with the registry where the image is located.
