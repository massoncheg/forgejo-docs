---
layout: '~/layouts/Markdown.astro'
title: 'Forgejo Actions user guide'
license: 'CC-BY-SA-4.0'
---

`Forgejo Actions` provides continuous integration driven from the files in the `.forgejo/workflows` directory of a repository. The syntax and semantic of the `workflow` files will be familiar to people used to [GitHub Actions](https://docs.github.com/en/actions) but **they are not and will never be identical**.

The following guide explains key **concepts** to help understand how `workflows` are interpreted, with a set of **examples** that can be copy/pasted and modified to fit particular use cases.

# Quick start

- Verify that `Enable Repository Actions` is checked in the `Repository` tab of the `/{owner}/{repository}/settings` page.
  ![enable actions](../../../../images/v1.20/user/actions/enable-repository.png)
- Add the following to the `.forgejo/workflows/demo.yaml` file in the repository.
  ```yaml
  on: [push]
  jobs:
    test:
      runs-on: docker
      steps:
        - run: echo All Good
  ```
  ![demo.yaml file](../../../../images/v1.20/user/actions/demo-yaml.png)
- Go to the `Actions` tab of the `/{owner}/{repository}/actions` page of the repository to see the result of the run.
  ![actions results](../../../../images/v1.20/user/actions/actions-demo.png)
- Click on the workflow link to see the details and the job execution logs.
  ![actions results](../../../../images/v1.20/user/actions/workflow-demo.png)

# Secrets

A repository or an organization can hold secrets, a set of key/value pairs that are stored encrypted in the `Forgejo` database and revealed to the `workflows` as `${{ secrets.KEY }}`. They can be defined from the web interface:

- in `/org/{org}/settings/actions/secrets` to be available in all the repositories that belong to the organization
- in `/{owner}/{repo}/settings/actions/secrets` to be available to the `workflows` of a single repository

![add a secret](../../../../images/v1.20/user/actions/secret-add.png)

Once the secret is added, its value cannot be changed or displayed.

![secrets list](../../../../images/v1.20/user/actions/secret-list.png)

# Concepts

## Forgejo runner

`Forgejo` itself does not run the `jobs`, it relies on the [Forgejo runner](https://code.forgejo.org/forgejo/runner) to do so. See the [Forgejo Actions administrator guide](../../admin/actions) for more information.

## Services

PostgreSQL, redis and other services can conveniently be run from container images with something similar to (see the [full example](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-service/.forgejo/workflows/test.yml)):

```yaml
services:
  pgsql:
    image: postgres:15
    env:
      POSTGRES_DB: test
      POSTGRES_PASSWORD: postgres
    ports:
      - '5432:5432'
```

A container with the specified `image:` is run before the `job` starts and is terminated when it completes. The job can address the service using its name, in this case `pgsql`.

## The machine running the workflow

Each `job` in a `workflow` must specify the kind of machine it needs to run its `steps` with `runs-on`. For instance `docker` in the following `workflow`:

```yaml
---
jobs:
  test:
    runs-on: docker
```

means that the `Forgejo runner` that claims to provide a kind of machine labelled `docker` will be selected by `Forgejo` and sent the job to be run.

The actual machine provided by the runner **entirely depends on how the `Forgejo runner` was registered** (see the [Forgejo Actions administrator guide](../../admin/actions) for more information).

The list of available `labels` for a given repository can be seen in the `/{owner}/{repo}/settings/actions/runners` page.

![actions results](../../../../images/v1.20/user/actions/list-of-runners.png)

### Container

By default the `docker` label will create a container from a [Node.js 16 Debian GNU/Linux bullseye image](https://hub.docker.com/_/node/tags?name=16-bullseye) and will run each `step` as root. Since an application container is used, the jobs will inherit the limitations imposed by the engine (Docker for instance). In particular they will not be able to run or install software that depends on `systemd`.

If the default image is unsuitable, a job can specify an alternate container image with `container:`, [as shown in this example](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-container/.forgejo/workflows/test.yml). For instance the following will ensure the job is run using [Alpine 3.18](https://hub.docker.com/_/alpine/tags?name=3.18).

```yaml
runs-on: docker
container:
  image: alpine:3.18
```

### LXC

The `runs-on: self-hosted` label will run the jobs in a [LXC](https://linuxcontainers.org/lxc/) container where software that rely on `systemd` can be installed. Nested containers can also be created recursively (see [the setup-forgejo integration tests](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/.forgejo/workflows/integration.yml) for an example).

`Services` are not supported for jobs that run on LXC.

# Examples

Each example is part of the [setup-forgejo](https://code.forgejo.org/actions/setup-forgejo/) action [test suite](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata).

- [Echo](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-echo/.forgejo/workflows/test.yml) - a single step that prints one sentence.
- [PostgreSQL service](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-service/.forgejo/workflows/test.yml) - a PostgreSQL service and a connection to display the (empty) list of tables of the default database.
- [Choosing the image with `container`](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-container/.forgejo/workflows/test.yml) - replacing the `runs-on: docker` image with the `alpine:3.18` image using `container:`.

# Glossary

- **workflow:** a file in the `.forgejo/workflows` directory that contains **jobs**.
- **job:** a sequential set of **steps**.
- **step:** a command the **runner** is required to carry out.
- **action:** a repository that can be used in a way similar to a function in any programming language to run a single **step**.
- **runner:** the [Forgejo runner](https://code.forgejo.org/forgejo/runner) daemon tasked to execute the **workflows**.
- **label** the kind of machine that is matched against the value of `runs-on` in a **workflow**.
