---
layout: '~/layouts/Markdown.astro'
title: 'Forgejo Actions user guide'
license: 'CC-BY-SA-4.0'
similar: 'https://github.com/go-gitea/gitea/blob/main/docs/content/doc/usage/actions/faq.en-us.md https://docs.github.com/en/actions'
---

`Forgejo Actions` provides Continuous Integration driven from the files in the `.forgejo/workflows` directory of a repository, with a web interface to show the results. The syntax and semantic of the `workflow` files will be familiar to people used to [GitHub Actions](https://docs.github.com/en/actions) but **they are not and will never be identical**.

The following guide explains key **concepts** to help understand how `workflows` are interpreted, with a set of **examples** that can be copy/pasted and modified to fit particular use cases.

# Quick start

- Verify that `Enable Repository Actions` is checked in the `Repository` tab of the `/{owner}/{repository}/settings` page. If the checkbox does not show it means the administrator of the Forgejo instance did not activate the feature.
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

# Concepts

## Forgejo runner

`Forgejo` itself does not run the `jobs`, it relies on the [Forgejo runner](https://code.forgejo.org/forgejo/runner) to do so. See the [Forgejo Actions administrator guide](../../admin/actions) for more information.

## Actions

An `Action` is a repository that contains the equivalent of a function in any programming language, with inputs and outputs as desccribed in the `action.yml` file at the root of the repository (see [this example](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/action.yml)).

One of the most commonly used action is [checkout](https://code.forgejo.org/actions/checkout#usage) which clones the repository that triggered a `workflow`. Another one is [setup-go](https://code.forgejo.org/actions/setup-go#usage) that will install Go.

Just as any other program of function, an `Action` has pre-requisites to successfully be installed and run. When looking at re-using an existing `Action`, this is an important consideration. For instance [setup-go](https://code.forgejo.org/actions/setup-go) depends on NodeJS during installation.

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

# The list of runners and their tasks

A `Forgejo runner` listens on a `Forgejo` instance, waiting for jobs. To figure out if a runner is available for a given repository, go to `/{owner}/{repository}/settings/actions/runners`. If there are none, you can run one for yourself on your laptop.

![list of runners](../../../../images/v1.20/user/actions/list-of-runners.png)

Some runners are **Global** and are available for every repository, others are only available for the repositories within a given user or organization. And there can even be runners dedicated to a single repository. The `Forgejo` administrator is the only one able to launch a **Global** runner. But the user who owns an organization can launch a runner without requiring any special permission. All they need to do is to get a runner registration token and install the runner on their own laptop or on a server of their choosing (see the [Forgejo Actions administrator guide](../../admin/actions) for more information).

Clicking on the pencil icon next to a runner shows the list of tasks it executed, with the status and a link to display the details of the execution.

![show the runners tasks](../../../../images/v1.20/user/actions/runner-tasks.png)

# The list of tasks in a repository

From the `Actions` tab in a repository, the list of ongoing and past tasks triggered by this repository is displayed with their status.

![the list of actions in a repository](../../../../images/v1.20/user/actions/actions-list.png)

Following the link on a task displays the logs and the `Re-run all jobs` button. It is also possible to re-run a specific job by hovering on it and clicking on the arrows.

![the details of an action](../../../../images/v1.20/user/actions/actions-detail.png)

# Tasks run from pull requests

The first time a user proposes a pull request, the task is blocked to reduce the security risks.

![blocked action](../../../../images/v1.20/user/actions/action-blocked.png)

It can be **Approve**d by a maintainer of the project and there will be no need to unblocker future pull requests.

![button to approve an action](../../../../images/v1.20/user/actions/action-approve.png)

# Secrets

A repository, a user or an organization can hold secrets, a set of key/value pairs that are stored encrypted in the `Forgejo` database and revealed to the `workflows` as `${{ secrets.KEY }}`. They can be defined from the web interface:

- in `/org/{org}/settings/actions/secrets` to be available in all the repositories that belong to the organization
- in `/user/settings/actions/secrets` to be available in all the repositories that belong to the logged in user
- in `/{owner}/{repo}/settings/actions/secrets` to be available to the `workflows` of a single repository

![add a secret](../../../../images/v1.20/user/actions/secret-add.png)

Once the secret is added, its value cannot be changed or displayed.

![secrets list](../../../../images/v1.20/user/actions/secret-list.png)

# Workflow reference guide

The syntax and semantic of the YAML file describing a `workflow` are partially explained here. When an entry is missing the [GitHub Actions](https://docs.github.com/en/actions) documentation can help because there are similarities. But there also are significant differences that deserve testing.

## on

Workflows will be triggered `on` certain events with the following:

```yaml
on:
  <event-name>:
    <event-parameter>:
    ...
```

e.g. to run a workflow when branch `main` is pushed

```yaml
on:
  push:
    branches:
      - main
```

| trigger event               | activity types                                                                                                           |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| create                      | not applicable                                                                                                           |
| delete                      | not applicable                                                                                                           |
| fork                        | not applicable                                                                                                           |
| gollum                      | not applicable                                                                                                           |
| push                        | not applicable                                                                                                           |
| issues                      | `opened`, `edited`, `closed`, `reopened`, `assigned`, `unassigned`, `milestoned`, `demilestoned`, `labeled`, `unlabeled` |
| issue_comment               | `created`, `edited`, `deleted`                                                                                           |
| pull_request                | `opened`, `edited`, `closed`, `reopened`, `assigned`, `unassigned`, `synchronize`, `labeled`, `unlabeled`                |
| pull_request_review         | `submitted`, `edited`                                                                                                    |
| pull_request_review_comment | `created`, `edited`                                                                                                      |
| release                     | `published`, `edited`                                                                                                    |
| registry_package            | `published`                                                                                                              |

Not everything from https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows is implemented yet. Please refer to the [forgejo/actions package source code](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/modules/actions/workflows.go) and the [list of webhook event names](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/modules/webhook/type.go) to find out about supported triggers.

## jobs

### runs-on

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

#### Container

By default the `docker` label will create a container from a [Node.js 16 Debian GNU/Linux bullseye image](https://hub.docker.com/_/node/tags?name=16-bullseye) and will run each `step` as root. Since an application container is used, the jobs will inherit the limitations imposed by the engine (Docker for instance). In particular they will not be able to run or install software that depends on `systemd`.

If the default image is unsuitable, a job can specify an alternate container image with `container:`, [as shown in this example](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-container/.forgejo/workflows/test.yml). For instance the following will ensure the job is run using [Alpine 3.18](https://hub.docker.com/_/alpine/tags?name=3.18).

```yaml
runs-on: docker
container:
  image: alpine:3.18
```

#### LXC

The `runs-on: self-hosted` label will run the jobs in a [LXC](https://linuxcontainers.org/lxc/) container where software that rely on `systemd` can be installed. Nested containers can also be created recursively (see [the setup-forgejo integration tests](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/.forgejo/workflows/integration.yml) for an example).

`Services` are not supported for jobs that run on LXC.

### steps

#### uses

Specifies the repository from which the `Action` will be cloned.

A relative `Action` such as `uses: actions/checkout@v3` will clone the repository at the URL composed by prepending the default actions URL which is https://code.forgejo.org/. It is the equivalent of providing the fully qualified URL `uses: https://code.forgejo.org/actions/checkout@v3`. In other words the following:

```yaml
on: [push]
jobs:
  test:
    runs-on: docker
    steps:
      - uses: actions/checkout@v3
```

is the same as:

```yaml
on: [push]
jobs:
  test:
    runs-on: docker
    steps:
      - uses: https://code.forgejo.org/actions/checkout@v3
```

When possible **it is strongly recommended to choose fully qualified
URLs** to avoid ambiguities. During installation, the `Forgejo'
instance may use another default URL and a workflow could fail because
it gets an outdated version from https://tooold.org/actions/checkout
instead. Or even a repository that does not contain the intended
action.

# Examples

Each example is part of the [setup-forgejo](https://code.forgejo.org/actions/setup-forgejo/) action [test suite](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata).

- [Echo](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-echo/.forgejo/workflows/test.yml) - a single step that prints one sentence.
- [PostgreSQL service](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-service/.forgejo/workflows/test.yml) - a PostgreSQL service and a connection to display the (empty) list of tables of the default database.
- [Choosing the image with `container`](https://code.forgejo.org/actions/setup-forgejo/src/branch/main/testdata/example-container/.forgejo/workflows/test.yml) - replacing the `runs-on: docker` image with the `alpine:3.18` image using `container:`.

# Glossary

- **workflow or task:** a file in the `.forgejo/workflows` directory that contains **jobs**.
- **job:** a sequential set of **steps**.
- **step:** a command the **runner** is required to carry out.
- **action:** a repository that can be used in a way similar to a function in any programming language to run a single **step**.
- **runner:** the [Forgejo runner](https://code.forgejo.org/forgejo/runner) daemon tasked to execute the **workflows**.
- **label** the kind of machine that is matched against the value of `runs-on` in a **workflow**.
