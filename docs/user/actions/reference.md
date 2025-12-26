---
title: Forgejo Actions | Reference
license: 'CC-BY-SA-4.0'
---

This page contains the complete reference for Forgejo Actions workflow files. For a more information on what the different parts of these files mean and how to use the syntax, check the [basic concepts](../basic-concepts/).

---

Jump to the [context reference](#contexts).

## Workflow Syntax

The syntax and semantics of the YAML file describing a `workflow` are _partially_ explained here. If something is not documented here, the [GitHub Actions documentation](https://docs.github.com/en/actions) may be helpful. However, GitHub Actions and Forgejo Actions _are not the same_ and things might not work right away.

Each chapter documents the function of one key in a workflow YAML file. Keys like `<job_id>` are placeholders for user-specified names.

### `name`

An optional name for the workflow. This name is displayed in the actions tab. If omitted, the name of the workflow file will be used.

### `on`

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

### `on.push`

Trigger the workflow when a commit or a tag is pushed.

If the `branches` event parameter is present, it will only be triggered if the a commit is pushed to one of the branches in the list.

If the `paths` event parameter is present, it will only be triggered if the a pushed commit modifies one of the path in the list.

If both `branches` and `paths` are present, the workflow will only be triggered if both match.

```yaml
on:
  push:
    branches:
      - 'mai*'
    paths:
      - '**/test.yml'
```

[Check out the push branches example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-push/.forgejo/workflows/test.yml).

If the `tags` event parameter is present, it will only be triggered if the the pushed tag matches one of the tags in the list.

```yaml
on:
  push:
    tags:
      - 'v1.*'
```

[Check out the push tags example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-tag/.forgejo/workflows/test.yml).

> **NOTE:** combining `tags` with `paths` or `branches` is not intended.

### `on.issues`

Trigger the workflow when an event happens on an issue or a pull request, as specified with the `types` event parameter. It defaults to `[opened, edited]` if not specified.

- `opened` the issue or pull request was created.
- `reopened` the closed issue or pull request was reopened.
- `closed` the issue or pull request was closed or merged.
- `labeled` a label was added.
- `unlabeled` a label was removed.
- `assigned` an assignee was added.
- `unassigned` an assignee was removed.
- `edited` the body, title or comments of the issue or pull request were modified.

```yaml
on:
  issues:
    types: [opened, edited]
```

### `on.pull_request`

Trigger the workflow when an event happens on a pull request, as specified with the `types` event parameter. It defaults to `[opened, synchronize, reopened]` if not specified.

- `opened` the pull request was created.
- `reopened` the closed pull request was reopened.
- `closed` the pull request was closed or merged.
- `labeled` a label was added.
- `unlabeled` a label was removed.
- `synchronize` the commits associated with the pull request were modified.
- `assigned` an assignee was added.
- `unassigned` an assignee was removed.
- `edited` the body, title or comments of the pull request were modified.

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]
```

If the head of a pull request is from a forked repository, the secrets are not available and the automatic token only has read permissions.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-pull-request/.forgejo/workflows/test.yml).

### `on.pull_request_target`

Trigger the workflow when an event happens on a pull request, and execute the workflow in the context of the **target branch** of the pull request. Specifically, it is similar to the `on.pull_request` event with the following exceptions:

- secrets stored in the base repository are available in the `secrets` `context`, (e.g. `${{ secrets.KEY }}`).
- the automatic token has write permission to the repository.
- the workflow runs in the context of the default branch of the base repository, meaning that:
  - changes to the workflow in the pull request will be ignored
  - the [actions/checkout](https://code.forgejo.org/actions/checkout) action will checkout the default branch instead of the content of the pull request

It is strongly recommended that workflows using `on.pull_request_target` do not interact with the untrusted code from the pull request, as it can be difficult to anticipate the security risks and side-effects. Although the workflow code itself is executed from the safe source of the target branch, its interactions with the untrusted code could compromise security. A known, non-exhaustive list of risks includes:

- All action steps are executed with the `FORGEJO_TOKEN` and `GITHUB_TOKEN` environment variables; interacting with untrusted code in the pull request may leak these tokens.
- The `actions/checkout` action will persist the security token unless configured with `persist-credentials: false`; untrusted code in the pull request may retrieve the token from disk and lead to it being leaked.
- Secrets that are used in action steps, for example as command-line parameters or environment variables, may be available to environment inspection by untrusted code leading to the risk of secret compromise.
- An `actions/cache` step introduces an opportunity for executed untrusted code in a pull request to poison cache contents which may later be used in a workflow that is executed with higher-level permissions, such as access to more secrets.

The safest configuration is to not checkout the code of the pull request at all.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-pull-request/.forgejo/workflows/test.yml).

### `on.release`

Trigger the workflow when an event happens on release, as
specified with the `types` event parameter.

- `published` the release was created.
- `edited` the body, title or comments of the release were modified.
- `deleted` the release was deleted.

```yaml
on:
  release:
    types: [published, edited, deleted]
```

### `on.schedule`

The `schedule` event allows you to trigger a workflow at a scheduled time. When a workflow with a `schedule` event is present in the default branch, Forgejo will add a task to run it at the designated time. The scheduled workflows on other branches or pull requests are ignored.

The scheduled time is specified using the [POSIX cron syntax](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/crontab.html#tag_20_25_07). See also the [crontab(5)](https://man.archlinux.org/man/crontab.5) manual page for a more information and some examples.

```yaml
on:
  schedule:
    - cron: '30 5,17 * * *'
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-cron/.forgejo/workflows/test.yml).

### `on.workflow_call`

The `workflow_call` event allows you to call a workflow from another workflow.

For example if the following workflow is found in `.forgejo/workflows/reusable.yml`:

```yaml
on:
  workflow_call:

jobs:
  callee:
    runs-on: docker
    steps:
      - run: echo OK
```

it can be called from another workflow as follows:

```yaml
on:
  push:

jobs:
  caller:
    runs-on: docker # (optional, see details in `jobs.<job_id>.uses`)
    uses: ./.forgejo/workflows/reusable.yml
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-workflow-call/.forgejo/workflows/test.yml).

### `on.workflow_call.inputs`

Inputs for a [`workflow_call`](#onworkflow_call) are declared in the `inputs` sub-key, where each sub-key itself is an input. Each of those inputs may have a `type`:

- `boolean`
- `number`
- `string`

Additionally, every input can be made `required`, given a human-readable `description`, and a `default` value.

```yaml
on:
  workflow_call:
    inputs:
      boolean:
        description: 'Boolean'
        required: false
        type: boolean
      number:
        description: 'Number'
        default: '100'
        type: number
      string:
        description: 'String'
        required: true
        type: string
```

Inputs then can be used inside the jobs with the `inputs` context:

```yaml
jobs:
  test:
    runs-on: docker
    steps:
      - run: echo ${{ inputs.number }}
```

Inputs are provided to a [`workflow_call`](#onworkflow_call) by using [`jobs.<job_id>.with`](#jobsjob_idwith).

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-workflow-call/.forgejo/workflows/reusable.yml).

### `on.workflow_call.outputs`

Outputs for a [`workflow_call`](#onworkflow_call) are declared in the `outputs` sub-key:

```yaml
outputs:
  name_of_the_output:
    value: value_of_the_output
```

A concrete example looks like this:

```yaml
on:
  workflow_call:
    outputs:
      output1:
        value: ${{ jobs.callee.outputs.job-output }}

jobs:
  callee:
    runs-on: docker
    outputs:
      job-output: ${{ steps.stepwithoutput.outputs.myvalue }}
    steps:
      - id: stepwithoutput
        run: |
          echo "myvalue=outputvalue1" >> $FORGEJO_OUTPUT
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-workflow-call/.forgejo/workflows/reusable.yml).

### `on.workflow_dispatch`

The `workflow_dispatch` events allows for manual triggering a workflow by either using the Forgejo UI, or the API with the `POST /repos/{owner}/{repo}/actions/workflows/{workflowname}/dispatches` endpoint. This event allows for inputs to be defined, which will get rendered in the Forgejo UI or read from the body of the API request.

Inputs are declared in the `inputs` sub-key, where each sub-key itself is an input. Each of those inputs need to have a `type`. These types can be:

- `choice`: A dropdown where the available options are defined as a list of strings with `options`
- `boolean`: A checkbox with the values of `true` or `false`
- `number`
- `string`

Additionally, every input can be made `required`, given a human-readable `description`, and a `default` value.

```yaml
on:
  workflow_dispatch:
    inputs:
      logLevel:
        description: 'Log Level'
        required: true
        default: 'warning'
        type: choice
        options:
          - info
          - warning
          - debug
      boolean:
        description: 'Boolean'
        required: false
        type: boolean
      number:
        description: 'Number'
        default: '100'
        type: number
      string:
        description: 'String'
        required: true
        type: string
```

Inputs then can be used inside the jobs with the `inputs` context:

```yaml
jobs:
  test:
    runs-on: docker
    steps:
      - run: echo ${{ inputs.logLevel }}
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-workflow-dispatch/.forgejo/workflows/test.yml).

### `enable-email-notifications`

Send an email notification when a workflow run fails or when it recovers from a failure (i.e. it succeeds and the previous run failed).

```yaml
enable-email-notifications: true
```

The email notification is sent to the user who triggered the workflow run (e.g. the author of a pull request, the user who pushed a commit, etc.), unless they disabled email notifications in their settings.

If a workflow run is not associated with a user (e.g. a run scheduled every day), the notification will be sent to:

- The user who owns the repository unless they disabled email notifications in their settings.
- The organization that owns the repository unless there is no contact email in its settings.

> **NOTE:** This setting has no effect on the actions webhooks.

### `env`

Set environment variables that are available in the workflow in the `env` context and as regular environment variables.

```yaml
env:
  KEY1: value1
  KEY2: value2
```

- The expression `${{ env.KEY1 }}` will be evaluated to `value1`
- The environment variable `KEY1` will be set to `value1`

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-expression/.forgejo/workflows/test.yml).

### `concurrency`

The concurrency settings control the concurrent executions of a workflow when triggered by multiple distinct events.

If no concurrency settings are provided, Forgejo will automatically manage the concurrency of a workflow that is executed by the `on.push` and `on.pull_request` (synchronize) events in the following manner: whenever a new event triggers a new workflow invocation, any other invocations of the same workflow will be canceled automatically.

Some common usages of `concurrency` include:

- If you're performing checks, such as automated tests in a software project, then it can be desirable to ignore older changes and focus on checking the most recent changes. The default behavior, omitting `concurrency` from your workflow, is usually fine.
- If you're performing releases of artifacts from a branch, then you may want to ensure each event's workflow is completed without being superseded by a later event. [`concurrency.cancel-in-progress`](#concurrencycancel-in-progress) can be set to `false` to aid this case, and [`concurrency.group`](#concurrencygroup) can be omitted.
- If you're performing deployments, then using [`concurrency.group`](#concurrencygroup) can be important so that only a single deployment occurs at one time. [`concurrency.cancel-in-progress`](#concurrencycancel-in-progress) is typically set to `false` to avoid canceling an in-progress deployment.

Multiple jobs within a workflow are not affected by the `concurrency` setting. [`jobs.<job_id>.needs`](#jobsjob_idneeds) can be used to introduce ordering between different jobs, which can prevent them from running concurrently if desired.

### `concurrency.group`

An optional concurrency group for the workflow. A concurrency group is a string that is defined by the workflow. When a concurrency group is present, Forgejo will make a best-effort to ensure that only a single workflow with the same concurrency group is executed at one time. The [contexts](#contexts) `forgejo`/`forge`/`github`, `inputs`, and `vars` can be referenced. Concurrency groups are case insensitive.

When multiple workflows are triggered from events with a concurrency group, the [`concurrency.cancel-in-progress`](#concurrencycancel-in-progress) setting determines _how_ only a single workflow will execute; either cancelling previous workflow runs, or queuing behind them.

For example:

```yaml
on: [push]
concurrency:
  group: deploy-${{ forgejo.ref }}
jobs:
  # ...
```

In this example, the concurrency group will evaluate to a string like `deploy-refs/heads/main`. Only a single workflow with this concurrency group will execute at once, even if multiple pushes occur to the `main` branch.

Forgejo makes a **best-effort** to ensure that only a single workflow with the same concurrency group is executed at one time by dispatching tasks to runners only when Forgejo believes no other runner is executing the workflow. However, in exceptional circumstances this cannot be guaranteed.

### `concurrency.cancel-in-progress`

`cancel-in-progress` is a boolean setting indicating whether to cancel the execution of other workflows when new events trigger new workflows. Variables from the [contexts](#contexts) `forgejo`/`forge`/`github`, `inputs`, and `vars` can be referenced.

If the [`concurrency.group`](#concurrencygroup) setting is not provided, then `cancel-in-progress` behaves as follows:

- If omitted, it will default to `true` for `on.push` and `on.pull_request` (synchronize) events.
- If evaluated to `true`, then any previous invocation of the same workflow with the same branch will be canceled, allowing the newest event to be processed as soon as possible.
- If evaluated to `false`, then no concurrency management will occur. Multiple invocations of the workflow may run simultaneously, as long as the available runner instances have capacity to execute the workflows.

Example:

```yaml
on: [push]
concurrency:
  cancel-in-progress: false
```

If the [`concurrency.group`](#concurrencygroup) setting is provided, then `cancel-in-progress` behaves as follows:

- If omitted, it will default to `true` for `on.push` and `on.pull_request` (synchronize) events.
- If evaluated to `true`, then any previous invocation of any workflow in the repository with the same concurrency group will be canceled, allowing the newest event to be processed as soon as possible.
- If evaluated to `false`, then any previous invocation of any workflow in the repository with the same concurrency group will be executed before the newer invocation, allowing each workflow to complete in sequence. Note that exact sequential ordering is not guaranteed; while typically workflows that were triggered earlier will be executed earlier, there are some edge-cases where this does not occur. For example, a workflow may be "re-run" through the UI even if later workflows have already been queued or completed.

Example:

```yaml
on: [push]
concurrency:
  group: deploy-${{ forgejo.ref }}
  cancel-in-progress: true
```

As the value of `cancel-in-progress` can be evaluated with an expression, it can be used to make workflows sequential conditionally; for example, the below configuration would cancel most workflows on a push, but allow multiple simultaneous workflows on `main`:

```yaml
on: [push]
concurrency:
  cancel-in-progress: ${{ forgejo.ref_name != 'main' }}
jobs:
  # ...
```

### `jobs`

The list of jobs in the workflow. The key to each job is a `job_id` and its content defines the sequential `step`s to be run.

Each job runs in a different container and shares nothing with other jobs.

All jobs run in parallel, unless they depend on each other as specified with [`jobs.<job_id>.needs`](#jobsjob_idneeds).

### `jobs.<job_id>`

Specifies the id for the job. This is used in some places to uniquely identify the job.

### `jobs.<job_id>.runs-on`

Specifies the kind of machine that is needed to run the `job`. For instance `docker` in the following `workflow`

```yaml
---
jobs:
  test:
    runs-on: docker
```

means that the job will only be sent to a `runner` which has declared the `docker` label.

You may have labels to differentiate between:

- Different running environments (Docker, Podman, LXC, host, etc.)
- Different default images (ubuntu-latest, alpine-latest, etc.)
- Different architectures (arm, x86_64, etc.)
- Specific hardware installed on the runner (nvidia-gpu, big-ram, etc.)

The actual machine provided by the runner **entirely depends on how the runner was registered** (see the [Forgejo Actions administrator guide](../../../admin/actions/) for more information).

The list of available `labels` for a given repository can be seen in the `/{owner}/{repo}/settings/actions/runners` page.

![a list of runners, with their associated labels](../../_images/user/actions/list-of-runners.png)

If your job specifies a label for which no runner is online, the job cannot be executed and your pipeline will halt until a runner with a matching label comes online. You will be able to see this in the Actions tab of your repository.

`runs-on` is typically a required field. However, if a job defines [`jobs.<job_id>.uses`](#jobsjob_iduses) in order to reference a reusable workflow, then it is optional. See [`jobs.<job_id>.uses`](#jobsjob_iduses) for more information on this behaviour.

### `jobs.<job_id>.if`

When specified, the job is only run if the **expression** evaluates to true.

For instance:

```yaml
---
jobs:
  build:
    if: forgejo.ref == 'refs/heads/main'
    steps:
      - run: echo only run on main branch
```

### `jobs.<job_id>.needs`

Can be used to introduce ordering between different jobs by listing their respective `<job_id>`. All jobs listed here must complete successfully before this job is considered for execution.

`needs` can either be a single string, naming a single job as pre-requisite, or an array for specifying multiple jobs to run before this one.

For instance:

```yaml
---
jobs:
  lint:
    steps:
      - run: echo linting the code
  build:
    needs:
      - lint
    steps:
      - run: echo only run after linting
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-needs/.forgejo/workflows/test.yml).

### `jobs.<job_id>.timeout-minutes`

Set the number of minutes this job can be performed before it is canceled.

```yaml
jobs:
  test:
    runs-on: docker
    timeout-minutes: 1
    steps:
      - run: sleep 2m
      - run: echo will never run
```

### `jobs.<job_id>.outputs`

The `jobs.<job_id>.outputs` object is a key/value map of the output of the
corresponding job, defined by writing to `$FORGEJO_OUTPUT`. For instance:

```yaml
on: [push]
jobs:
  job1:
    runs-on: docker
    outputs:
      job1output: ${{ steps.step1.outputs.value }}
    steps:
      - id: step1
        run: |
          set -x
          echo "value=value1" >> $FORGEJO_OUTPUT
```

This output can then be used in jobs that run after it completes (i.e. that need it in the sense of [`jobs.<job_id>.needs`](#jobsjob_idneeds)). For instance:

```yaml
job2:
  needs: [job1]
  runs-on: docker
  steps:
    - run: |
        set -x
        test "${{ needs.job1.outputs.job1output }}" = "value1"
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-needs/.forgejo/workflows/test.yml).

### `jobs.<job_id>.uses`

Specifies the reusable workflow to call with a `workflow_call` event. `uses` can be specified in one of three supported formats:

- `./.forgejo/workflows/reusable.yml` -- refers to a workflow file within the same repository as the current workflow is defined.
- `some-org/some-repo/.forgejo/workflows/reusable.yml@main` -- refers to a workflow file within a different repository (`some-org/some-repo`), at a specified path and Git reference (`main`). The target repository must be a public repository.
- `https://example.com/some-org/some-repo/.forgejo/workflows/reusable.yml@main` -- refers to a workflow file hosted remotely by a different Forgejo or GitHub instance. The target repository must be a public reposistory.

If [`jobs.<job_id>.runs-on`](#jobsjob_idruns-on) field is absent, then Forgejo will attempt to perform workflow expansion on the reusable workflow. Workflow expansion results in the target workflow's jobs being handled as individual jobs which can be executed on separate runners. When multiple jobs are present in the workflow, this provides an easier to understand experience for accessing the logs, and permits the jobs to run on separate runners with their own `runs-on` fields.

Workflow expansion has limited support:

- `with:` or `secrets:` to provide inputs to a job is not supported
- `on.workflow_call.outputs` to receive outputs from the job is not supported
- A workflow file hosted remotely by a different Forgejo or GitHub instance is not supported, and will automatically disable workflow expansion.

Workflow expansion can be disabled by providing a value for [`jobs.<job_id>.runs-on`](#jobsjob_idruns-on).

See [`on.workflow_call`](#onworkflow_call) for more information on defining a workflow call.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-workflow-call/.forgejo/workflows/test.yml).

### `jobs.<job_id>.with`

A dictionary mapping the inputs of the `workflow_call` event to concrete values. See [`on.workflow_call.inputs`](#onworkflow_callinputs) for more information on how the inputs are declared in reusable workflow.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-workflow-call/.forgejo/workflows/test.yml).

### `jobs.<job_id>.secrets`

Controls the secrets provided to the reusable workflow being called. It can either be `secrets: inherit` in which case the reusable workflow will have access to the same secrets as the caller. Or it can be a dictionary mapping a selection of secrets. For instance in the following, the reusable workflow will get `keep_it_private` as the result of evaluating the expression `${{ secrets.secret }}`:

```yaml
on:
  push:

jobs:
  caller:
    runs-on: docker
    uses: ./.forgejo/workflows/reusable.yml
    secrets:
      secret: keep_it_private
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-workflow-call/.forgejo/workflows/test.yml).

### `jobs.<job_id>.name`

The name of the job. If not set, the name of the job defaults to `<job_id>`.
The expressions it contains will be interpolated. For instance if the variable `SOME` is set to `THING`, in the following:

```yaml
jobs:
  test:
    name: jobname-${{ vars.SOME }}
```

The name of the job will be `jobname-THING`.

### `jobs.<job_id>.strategy.matrix`

If present, it will generate a matrix from the content of the object
and create one job per cell in the matrix instead of a single job.

For instance:

```yaml
jobs:
  test:
    runs-on: self-hosted
    strategy:
      matrix:
        variant: ['bookworm', 'bullseye']
        node: ['18', '20']
    steps:
      - uses: https://code.forgejo.org/actions/setup-node@v4
        with:
          node-version: '${{ matrix.node }}'
```

Will create four jobs where:

- `matrix.variant` = "bookworm" & `matrix.node` = "18"
- `matrix.variant` = "bookworm" & `matrix.node` = "20"
- `matrix.variant` = "bullseye" & `matrix.node` = "18"
- `matrix.variant` = "bullseye" & `matrix.node` = "20"

They each run independently and can use the `matrix` context to access these values, like in the `node-version` key in the snippet.

The `strategy.matrix` option can calculate the jobs to be created, typically by using the `fromJSON` evaluation function. The following snippet contains the same four job matrix defined above, but the matrix options can be defined by the `matrix-generator` job. The test job `needs` the `matrix-generator` job so that it is executed first and defines the job matrix:

```yaml
jobs:
  matrix-generator:
    runs-on: docker
    outputs:
      variants: ${{ steps.generate_matrix.outputs.variants }}
      nodes: ${{ steps.generate_matrix.outputs.nodes }}
    steps:
      - id: generate_matrix
        run: |
          echo 'variants=["bookworm", "bullseye"]' >> $GITHUB_OUTPUT
          echo 'nodes=["18", "20"]' >> $GITHUB_OUTPUT
  test:
    needs: matrix-generator
    runs-on: docker
    strategy:
      matrix:
        variant: ${{ fromJSON(needs.matrix-generator.outputs.variants) }}
        node: ${{ fromJSON(needs.matrix-generator.outputs.nodes) }}
    container:
      image: debian:${{ matrix.obj.variant }}
    steps:
      - uses: https://code.forgejo.org/actions/setup-node@v4
        with:
          node-version: '${{ matrix.node }}'
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/commit/b6591e2f71196b12f6e0851774f0bd6e2148ec18/.forgejo/workflows/actions.yml#L22-L37).

> **NOTE:** if `jobs.<job_id>.name` is set, care must be taken that it evaluates to a unique name for each job created from the matrix, e.g. `name-${{ matrix.variant }}-${{ matrix.node}}` in the above example.

### `jobs.<job_id>.container.image`

- **Docker or Podman:**
  If the default image is unsuitable, a job can specify an alternate container image with `container:`, [as shown in this example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-container/.forgejo/workflows/test.yml). For instance the following will ensure the job is run using [Alpine 3.20](https://hub.docker.com/_/alpine/tags?name=3.20).

  > **Note:** Many `Actions` require node to run. Using a custom container image that does not contain node may cause these actions to break.

  ```yaml
  runs-on: docker
  container:
    image: alpine:3.20
  ```

- **LXC:**
  If the default [template and release](https://images.linuxcontainers.org/) specified by the runner are unsuitable, a job can specify an alternate template and release as follows.

  ```yaml
  runs-on: lxc
  container:
    image: debian:bookworm
  ```

> **Note:** The `env` context cannot be used in expressions to construct the image name. For instance `image: ${{ env.MYVARIABLE }}` is not allowed.

### `jobs.<job_id>.container.env`

Set environment variables in the container.

> **NOTE:** ignored if `jobs.<job_id>.runs-on` is an LXC container.

### `jobs.<job_id>.container.credentials`

If the image's container registry requires authentication to pull the image, `username` and `password` will be used.
The credentials are the same values that you would provide to the `docker login` command. For instance:

```yaml
runs-on: docker
container:
  image: alpine:3.20
  credentials:
    username: 'root'
    password: 'admin1234'
```

> **NOTE:** ignored if `jobs.<job_id>.runs-on` is an LXC container.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-container/.forgejo/workflows/test.yml)

### `jobs.<job_id>.container.volumes`

Set the volumes for the container to use, as if provided with the `--volume` argument of the `docker run` command.

> **NOTE:** the `--volume` option is restricted to a allowlist of volumes configured in the runner executing the task. See the [Forgejo runner installation guide](../../../admin/actions/runner-installation/#configuration) for more information.

> **NOTE:** ignored if `jobs.<job_id>.runs-on` is an LXC container.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-context/.forgejo/workflows/test.yml)

### `jobs.<job_id>.container.options`

A string of the following additional options, as documented [docker run](https://docs.docker.com/engine/reference/commandline/run/).

- `--volume`
- `--tmpfs`
- `--hostname` (except for Forgejo runner 6.0.x and 6.1.x)
- `--memory` (requires runner 11.2.0 or greater)

> **NOTE:** the `--volume` option is restricted to a allowlist of volumes configured in the runner executing the task. See the [Forgejo Actions administrator guide](../../../admin/actions/) for more information.

> **NOTE:** the value of `--memory` cannot be higher than the value set in the runner configuration file in `[container].options`, if any.

> **NOTE:** ignored if `jobs.<job_id>.runs-on` is an LXC container.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-service/.forgejo/workflows/test.yml)

### `jobs.<job_id>.services`

The map of services to run before the job starts and terminate when it completes. The key determines the name of the host where the
service runs. For instance:

```yaml
services:
  pgsql:
    image: postgres:15
      POSTGRES_DB: test
      POSTGRES_PASSWORD: postgres
steps:
  - run: PGPASSWORD=postgres psql -h pgsql -U postgres -c '\dt' test
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-service/.forgejo/workflows/test.yml)

The following values are the same as [service container syntax](../advanced-features/#services).

### `jobs.<job_id>.services.image`

See also `jobs.<job_id>.container.image`

### `jobs.<job_id>.services.credentials`

See also `jobs.<job_id>.container.credentials`

### `jobs.<job_id>.services.env`

See also `jobs.<job_id>.container.env`

### `jobs.<job_id>.services.volumes`

See also `jobs.<job_id>.container.volumes`

### `jobs.<job_id>.services.options`

See [`services.<service_name>.options`](../advanced-features/#servicesservice_nameoptions)

### `jobs.<job_id>.steps`

An array of steps executed sequentially on the host specified by `runs-on`.

### `jobs.<job_id>.steps.if`

The steps are run if the **expression** evaluates to true.

For instance:

```yaml
jobs:
  my-job:
    steps:
      - name: some-step
        # This step runs when the event that triggerend the workflow was the opening of a pull request
        if: ${{ forgejo.event_name == 'pull_request' && forgejo.event.action == 'opened' }}
      - name: another-step
        # This step runs when the event that triggered the workflow was the closing of a pull request
        if: ${{ forgejo.event_name == 'pull_request' && forgejo.event.action == 'closed' }}
```

### `jobs.<job_id>.defaults.run.shell`

Set the default shell to use for each step.

```yaml
jobs:
  test:
    runs-on: docker
    defaults:
      run:
        shell: sh
    steps:
      - run: echo SUCCESS
```

See [`jobs.<job_id>.steps[*].shell`](#jobsjob_idstepsshell) for more information on the shell values and their semantics.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-shell/.forgejo/workflows/test.yml)

### `jobs.<job_id>.steps[*].run`

A shell script to run in the environment specified with
`jobs.<job_id>.runs-on`. It runs as root using the default shell unless
specified otherwise with `jobs.<job_id>.steps[*].shell`. For instance:

```yaml
jobs:
  test:
    runs-on: docker
    container:
      image: alpine:latest
    steps:
      - run: |
          grep Alpine /etc/os-release
          echo SUCCESS
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-container/.forgejo/workflows/test.yml)

### `jobs.<job_id>.steps[*].working-directory`

The working directory from which the script specified with `jobs.<job_id>.step[*].run` will run. For instance:

```yaml
- run: test $(pwd) = /tmp
  working-directory: /tmp
```

### `jobs.<job_id>.steps[*].shell`

The interpreter used to run the script specified with `jobs.<job_id>.step[*].run`. If the interpreter is not specified, it defaults to `bash` or `sh` if `bash` is not available.

> **NOTE:** The fallback to `sh` if `bash` is not available requires a version of [Forgejo runner >= v8.0.0](https://code.forgejo.org/forgejo/runner/src/branch/main/RELEASE-NOTES.md#8-0-0).

The value is a command line where the literal string `{0}` is replaced with the path to a (temporary) file, containing the content of `jobs.<job_id>.steps[*].run`. For example `dash -e {0}` would become `dash -e /tmp/xxx`.

```yaml
jobs:
  test:
    runs-on: docker
    container:
      image: debian:bookworm
    steps:
      - shell: dash -e {0}
        run: echo using dash here
```

Some commonly used interpreters have abbreviated aliases that are expanded into command lines as follows:

- `bash` => `bash --noprofile --norc -e -o pipefail {0}`
- `sh` => `sh -e {0}`
- `node` => `node {0}`
- `python` => `python {0}`

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-shell/.forgejo/workflows/test.yml)

### `jobs.<job_id>.steps[*].id`

A unique identifier for the step. You will only need this if you want to refer to inputs or outputs from this step, for example using the `steps.<step_id>.outputs` context.

### `jobs.<job_id>.steps[*].if`

The step is run if the **expression** evaluates to true.

Check out the workflows in [example-if](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-if/) and [example-if-fail](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-if-fail/).

### `jobs.<job_id>.steps[*].uses`

Specifies the repository from which the `Action` will be cloned or a directory where it can be found.

- **Remote actions**
  A relative `Action` such as `uses: actions/checkout@v4` will clone the repository at the URL composed by prepending the `DEFAULT_ACTIONS_URL` (`https://data.forgejo.org` by default, see note below). It is the equivalent of providing the fully qualified URL `uses: https://data.forgejo.org/actions/checkout@v4`. In other words the following:

  ```yaml
  on: [push]
  jobs:
    test:
      runs-on: docker
      steps:
        - uses: actions/checkout@v4
  ```

  is the same as:

  ```yaml
  on: [push]
  jobs:
    test:
      runs-on: docker
      steps:
        - uses: https://data.forgejo.org/actions/checkout@v4
  ```

  > **NOTE:** When possible **it is strongly recommended to choose fully qualified URLs** to avoid ambiguities. During installation, the instance administrator may change the `DEFAULT_ACTIONS_URL`. This can cause your workflow to break if the actions you want to use are not available on the specified instance.

  The string after the `@` specifies the version of the action. There are various ways of specifying a version:

  ```yaml
  steps:
    # Using the commit SHA of a specific commit.
    - uses: actions/checkout@09d2acae674a48949e3602304ab46fd20ae0c42f
    # Using the full name of a tag.
    - uses: actions/checkout@v4.2.0
    # Using part of the name of a tag to match the newest version of that tag.
    - uses: actions/checkout@v4
    # Using the name of a branch
    - uses: actions/checkout@main
  ```

  Because it is possible to [compromise tags](https://nvd.nist.gov/vuln/detail/cve-2025-30066), it is recommended to use commit SHAs for security reasons.

- **Remote container actions**
  An OCI container can be used as an action. You may specify a container action with `uses: docker://[host]/[container]:[tag]`.

  For example, the YAML

  ```yaml
  uses: docker://code.forgejo.org/actions/some-action:latest
  ```

  would get the `latest` version of the `some-action` container by user `actions` from `code.forgejo.org`.

- **Local actions**
  An action that begins with a `./` will be loaded from a directory
  instead of being cloned from a repository. The structure of the
  directory is otherwise the same as if it was located in a remote
  repository.

  > **NOTE:** the most common mistake when using an action included in the repository under test is to forget to checkout the repository with `uses: actions/checkout@v4`.

  [Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-local-action/).

### `jobs.<job_id>.steps[*].with`

A dictionary mapping the inputs of the action to concrete values. The `action.yml` defines and documents the inputs.

```yaml
on: [push]
jobs:
  ls:
    runs-on: docker
    steps:
      - uses: ./.forgejo/local-action
        with:
          input-two: 'two'
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-local-action/.forgejo/workflows/test.yml)

### `jobs.<job_id>.steps[*].with.args`

For actions that are implemented with a `Dockerfile`, the `args` key is used to override the `CMD` passed to the `ENTRYPOINT` of the container. If not specified the `CMD` from the `Dockerfile` will be used.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-docker-action/.forgejo/workflows/test.yml)

### `jobs.<job_id>.steps[*].with.entrypoint`

For actions that are implemented with a `Dockerfile`, the `entrypoint` key is used to overrides the `ENTRYPOINT` in the Dockerfile. It must be the path to the executable file to run.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-docker-action/.forgejo/workflows/test.yml)

### `jobs.<job_id>.steps[*].env`

Set environment variables like it's [top-level variant `env`](#env), but only for the current step.

### `jobs.<job_id>.steps[*].continue-on-error`

It set to `true` on a step, the step won't cause the job to fail if it fails. Following steps will still run, and if they succeed the job will be marked successful.

```yaml
steps:
  - run: echo "failing step" && false
    continue-on-error: true
  - run: echo "this step runs and job is successful"
```

When a step with `continue-on-error` fails, its `steps.<step_id>.outcome` will be `failure`, but its `steps.<step_id>.conclusion` will be `success`.

### `jobs.<job_id>.steps[*].timeout-minutes`

Set the number of minutes this step can be performed before it is canceled.

```yaml
steps:
  - run: sleep 301
    timeout-minutes: 5
  - run: echo "this will not get run"
```

## Contexts

A context is an object that contains information relevant to a `workflow` run. For instance the `secrets` context contains the secrets defined in the repository. Each of the following context is defined as a top-level variable when evaluating expressions. For instance `${{ secrets.MYSECRET }}` will be replaced by the value of `MYSECRET`.

| Context name     | Description                                     |
| ---------------- | ----------------------------------------------- |
| secrets          | secrets available in the repository             |
| vars             | variables available in the repository           |
| env              | environment variables defined in the workflow   |
| forgejo or forge | information about the workflow being run        |
| matrix           | information about the current row of the matrix |
| steps            | information about the steps that have been run  |
| needs            | information about the jobs that have been run   |
| inputs           | the input parameters given to an action         |

To help with reusing actions and workflows originally developed for GitHub Actions, the `github` context is defined to be the same as the `forgejo` context.

### Availability

Some contexts like `secrets` can only be accessed in certain places. Likewise, functions can be restricted to certain workflow keys. The following table lists which contexts and functions are available where.

| Workflow key                                       | Accessible contexts                                                                                    | Accessible functions                                     |
| -------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | -------------------------------------------------------- |
| `run-name`                                         | `forgejo`, `inputs`, `vars`                                                                            | -                                                        |
| `concurrency`                                      | `forgejo`, `inputs`, `vars`                                                                            | -                                                        |
| `env`                                              | `env`, `forgejo`, `inputs`, `secrets`, `vars`                                                          | -                                                        |
| `jobs.<job-id>.concurrency`                        | `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                             | -                                                        |
| `jobs.<job-id>.container`                          | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.container.credentials`              | `env`, `forgejo`, `inputs`, `secrets`, `vars`                                                          | -                                                        |
| `jobs.<job-id>.container.env.<env-id>`             | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `strategy`, `vars`          | -                                                        |
| `jobs.<job-id>.container.image`                    | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.container.options`                  | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.container.volumes.[*]`              | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.continue-on-error`                  | `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                             | -                                                        |
| `jobs.<job-id>.defaults.run`                       | `env`, `forgejo`, `inputs `, `matrix`, `needs`, `strategy`, `vars`                                     | -                                                        |
| `jobs.<job-id>.env`                                | `forgejo`, `inputs`, `matrix`, `needs`, `secrets`, `strategy`, `vars`                                  | -                                                        |
| `jobs.<job-id>.environment`                        | `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                             | -                                                        |
| `jobs.<job-id>.environment.url`                    | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `steps`, `strategy`, `vars`            | -                                                        |
| `jobs.<job-id>.if`                                 | `env`, `forgejo`, `inputs`, `needs`, `secrets`, `vars`                                                 | `always`, `cancelled`, `failure`, `success`              |
| `jobs.<job-id>.name`                               | `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                             | -                                                        |
| `jobs.<job-id>.outputs.<output-id>`                | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | -                                                        |
| `jobs.<job-id>.runs-on`                            | `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                             | -                                                        |
| `jobs.<job-id>.secrets.<secret_id>`                | `forgejo`, `inputs`, `matrix`, `needs`, `secrets`, `strategy`, `vars`                                  | -                                                        |
| `jobs.<job-id>.services`                           | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.services.<service-id>`              | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.services.<service-id>.cmd.[*]`      | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.services.<service-id>.credentials`  | `env`, `forgejo`, `inputs`, `secrets`, `vars`                                                          | -                                                        |
| `jobs.<job-id>.services.<service-id>.env.<env-id>` | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `strategy`, `vars`          | -                                                        |
| `jobs.<job-id>.services.<service-id>.image`        | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.services.<service-id>.options`      | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.services.<service-id>.ports.[*]`    | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.services.<service-id>.volumes.[*]`  | `env`, `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                      | -                                                        |
| `jobs.<job-id>.steps[*].continue-on-error`         | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.steps[*].env`                       | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.steps[*].if`                        | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `always`, `cancelled`, `failure`, `success`, `hashFiles` |
| `jobs.<job-id>.steps[*].name`                      | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.steps[*].run`                       | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.steps[*].timeout-minutes`           | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.steps[*].uses`                      | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.steps[*].with`                      | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.steps[*].working-directory`         | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.strategy`                           | `forgejo`, `inputs`, `needs`, `vars`                                                                   | -                                                        |
| `jobs.<job-id>.strategy.fail-fast`                 | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.strategy.max-parallel`              | `env`, `forgejo`, `inputs`, `job`, `matrix`, `needs`, `runner`, `secrets`, `steps`, `strategy`, `vars` | `hashFiles`                                              |
| `jobs.<job-id>.timeout-minutes`                    | `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                             | -                                                        |
| `jobs.<job-id>.with.<with-id>`                     | `forgejo`, `inputs`, `matrix`, `needs`, `strategy`, `vars`                                             | -                                                        |
| `on.workflow_call.inputs.<input-id>.default`       | `forgejo`, `vars` [^1]                                                                                 | -                                                        |
| `on.workflow_call.outputs.<output-id>.value`       | `forgejo`, `inputs`, `jobs`, `vars`                                                                    | -                                                        |

When you are manipulating a particular context like `env`, you cannot reference context variables defined within the same workflow key. Therefore, the following example will **not** work:

```yaml
on:
  push:
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Invalid context reference
        run: |
          echo "$IS_PUSH"
        env:
          EVENT: '${{ forgejo.event_name}}'
          IS_PUSH: "${{ env.EVENT == 'push' }}" # false because env.EVENT is undefined
```

[^1]: While GitHub Actions permits accessing `inputs` in `on.workflow_call.inputs.<input-id>.default`, [it is always empty](https://codeberg.org/forgejo/forgejo/issues/9768#issuecomment-8852121). Therefore, Forgejo Runner does not make it available.

### secrets

A map of the repository secrets. It is empty if the `event` that triggered the `workflow` is `pull_request` and the head is from a fork of the repository.

Example: `${{ secrets.MYSECRETS }}`

### vars

A map of the repository variables.

Example: `${{ vars.MYVARIABLE }}`

### env

A map of the environment variables defined in the workflow.

Example: `${{ env.SOMETHING }}`

In addition, the variables listed in the following table are injected into the environment of the shell executing a particular step. However, they are not included in `env` and can therefore not be referenced when defining a workflow.

| Name                      | Description                                                                                                                                                      |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CI                        | Always set to true.                                                                                                                                              |
| FORGEJO_ACTION            | The numerical id of the current step.                                                                                                                            |
| FORGEJO_ACTION_PATH       | When evaluated while running a `composite` action (i.e. `using: "composite"`, the path where an action files are located.                                        |
| FORGEJO_ACTION_REPOSITORY | For a step executing an action, this is the owner and repository name of the action (e.g. `actions/checkout`).                                                   |
| FORGEJO_ACTIONS           | Set to true when the Forgejo runner is running the workflow on behalf of a Forgejo instance. Set to false when running the workflow from `forgejo-runner exec`.  |
| FORGEJO_ACTOR             | The name of the user that triggered the `workflow`.                                                                                                              |
| FORGEJO_API_URL           | The API endpoint of the Forgejo instance running the workflow (e.g. https://code.forgejo.org/api/v1).                                                            |
| FORGEJO_BASE_REF          | The name of the base branch of the pull request (e.g. main). Only defined when a workflow runs because of a `pull_request` or `pull_request_target` event.       |
| FORGEJO_HEAD_REF          | The name of the head branch of the pull request (e.g. my-feature). Only defined when a workflow runs because of a `pull_request` or `pull_request_target` event. |
| FORGEJO_ENV               | The path on the runner to the file that sets variables from workflow commands. This file is unique to the current step and changes for each step in a job.       |
| FORGEJO_EVENT_NAME        | The name of the event that triggered the workflow (e.g. `push`).                                                                                                 |
| FORGEJO_EVENT_PATH        | The path to the file on the Forgejo runner that contains the full event webhook payload.                                                                         |
| FORGEJO_HEAD_REF          | The name of the head branch of the pull request (e.g. my-feature). Only defined when a workflow runs because of a `pull_request` or `pull_request_target` event. |
| FORGEJO_JOB               | The `job_id` of the current job.                                                                                                                                 |
| FORGEJO_OUTPUT            | The path on the runner to the file that sets the current step's outputs. This file is unique to the current step.                                                |
| FORGEJO_PATH              | The path on the runner to the file that sets the PATH environment variable. This file is unique to the current step.                                             |
| FORGEJO_REF               | The fully formed git reference (i.e. starting with `refs/`) associated with the event that triggered the workflow, if any (e.g. `refs/heads/main`).              |
| FORGEJO_REF_NAME          | The short git reference name of the branch or tag associated with the workflow, if any (e.g. `main`).                                                            |
| FORGEJO_REPOSITORY        | The owner and repository name (e.g. forgejo/docs).                                                                                                               |
| FORGEJO_REPOSITORY_OWNER  | The repository owner's name (e.g. forgejo)                                                                                                                       |
| FORGEJO_RUN_ATTEMPT       | Attempt number for this run, beginning at 1 and incrementing when the job is re-run.                                                                             |
| FORGEJO_RUN_NUMBER        | A unique id for the current workflow run in the repository of the workflow.                                                                                      |
| FORGEJO_RUN_ID            | A unique id for the current workflow run in the Forgejo instance.                                                                                                |
| FORGEJO_SERVER_URL        | The URL of the Forgejo instance running the workflow (e.g. https://code.forgejo.org)                                                                             |
| FORGEJO_SHA               | The commit SHA that triggered the workflow. The value of this commit SHA depends on the event that triggered the workflow.                                       |
| FORGEJO_TOKEN             | The unique authentication token automatically created for duration of the workflow.                                                                              |
| FORGEJO_WORKSPACE         | The default working directory on the runner for steps, and the default location of the repository when using the checkout action.                                |
| FORGEJO_WORKFLOW_REF      | Ref path to the workflow, for example, `owner/example-respository/.forgejo/workflows/test-workflow.yaml@refs/heads/main`                                         |

To help with reusing actions and workflows originally developed for GitHub Actions, each `FORGEJO_*` variable is also available as a `GITHUB_*` variable with the same suffix (e.g. `GITHUB_REPOSITORY` is the same as `FORGEJO_REPOSITORY`).

> **NOTE:** the `FORGEJO_*` variables require [Forgejo runner v7.0.0](https://code.forgejo.org/forgejo/runner/src/branch/main/RELEASE-NOTES.md#7-0-0) or above. With earlier versions only the `GITHUB_*` variables were defined.

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-context/.forgejo/workflows/test.yml).

### github

To help with reusing actions and workflows originally developed for GitHub Actions, the `github` context is defined to be the same as the `forgejo` context.

### forgejo

The following are identical to the matching environment variable
(e.g. `forgejo.base_ref` is the same as `env.FORGEJO_BASE_REF`):

> **NOTE:** the `forge` context is the same as the `forgejo` context.

| Name              | Description                                                                                                                                                      |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| action            | The numerical id of the current step.                                                                                                                            |
| action_path       | When evaluated while running a `composite` action (i.e. `using: "composite"`, the path where an action files are located.                                        |
| action_repository | For a step executing an action, this is the owner and repository name of the action (e.g. `actions/checkout`).                                                   |
| actor             | The name of the user that triggered the `workflow`.                                                                                                              |
| api_url           | The API endpoint of the Forgejo instance running the workflow (e.g. https://code.forgejo.org/api/v1).                                                            |
| base_ref          | The name of the base branch of the pull request (e.g. main). Only defined when a workflow runs because of a `pull_request` or `pull_request_target` event.       |
| event             | JSON object containing event details of how the workflow was triggered; details vary depending on the event.                                                     |
| event_name        | The name of the event that triggered the workflow (e.g. `push`).                                                                                                 |
| event_path        | The path to the file on the Forgejo runner that contains the full event webhook payload.                                                                         |
| head_ref          | The name of the head branch of the pull request (e.g. my-feature). Only defined when a workflow runs because of a `pull_request` or `pull_request_target` event. |
| job               | The `job_id` of the current job.                                                                                                                                 |
| output            | The path on the runner to the file that sets the current step's outputs. This file is unique to the current step.                                                |
| path              | The path on the runner to the file that sets the PATH environment variable. This file is unique to the current step.                                             |
| ref               | The fully formed git reference (i.e. starting with `refs/`) associated with the event that triggered the workflow, if any (e.g. `refs/heads/main`).              |
| ref_name          | The short git reference name of the branch or tag associated with the workflow, if any (e.g. `main`).                                                            |
| repository        | The owner and repository name (e.g. forgejo/docs).                                                                                                               |
| repository_owner  | The repository owner's name (e.g. forgejo)                                                                                                                       |
| run_id            | A unique id for the current workflow run in the Forgejo instance.                                                                                                |
| run_number        | A unique id for the current workflow run in the repository of the workflow.                                                                                      |
| run_attempt       | Attempt number for this run, beginning at 1 and incrementing when the job is re-run.                                                                             |
| server_url        | The URL of the Forgejo instance running the workflow (e.g. https://code.forgejo.org)                                                                             |
| sha               | The commit SHA that triggered the workflow. The value of this commit SHA depends on the event that triggered the workflow.                                       |
| token             | The unique authentication token automatically created for duration of the workflow.                                                                              |
| workspace         | The default working directory on the runner for steps, and the default location of the repository when using the checkout action.                                |
| workflow_ref      | Ref path to the workflow, for example, `owner/example-respository/.forgejo/workflows/test-workflow.yaml@refs/heads/main`                                         |

Example: `${{ forgejo.SHA }}`

In addition, the `forgejo` context contains the `forgejo.event` object
which is set to the payload associated with the event
(`forgejo.event_name`) that triggered the workflow.

To find out what this payload is made of, insert a job at the
beginning of the workflow to display the entire context in the web
UI. For instance:

```yaml
debug:
  runs-on: docker
  steps:
    - name: event
      run: |
        cat <<'EOF'
        ${{ toJSON(forgejo) }}
        EOF
```

will show something similar to the following when a label is updated in a pull request:

```json
{
  "event": {
    "action": "label_updated",
    "commit_id": "",
    "label": {
      "color": "795548",
      "description": "Issue or pull request related to testing",
      "exclusive": false,
      "id": 23,
      "is_archived": false,
      "name": "Kind/Testing",
      "url": "https://code.forgejo.org/api/v1/repos/forgejo/runner/labels/23"
    },
    "number": 948,
    "pull_request": {
...
  "workflow": "cascade",
  "run_attempt": "1",
  "run_id": "117195",
  "run_number": "9384",
  "actor": "earl-warren",
  "repository": "forgejo/runner",
  "event_name": "pull_request_target",
  "sha": "09adcc47d250567412c2fc2083ed7dcf61a7b953",
  "ref": "refs/heads/main",
  "ref_name": "main",
  "ref_type": "branch",
  "head_ref": "wip-cascade",
  "base_ref": "main",
  "token": "***",
  "workspace": "/workspace/forgejo/runner",
...
```

> **NOTE:** although the automatic token is masked (see `***` in the example above), it is not advisable to display this on a publicly readable instance.

### matrix

An object that exists in the context of a job where `jobs.<job_id>.strategy.matrix` is defined . For instance:

```yaml
jobs:
  actions:
    runs-on: self-hosted
    strategy:
      matrix:
        info:
          - version: v1.22
            branch: next
```

Example: `${{ matrix.info.version }}`

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/commit/b6591e2f71196b12f6e0851774f0bd6e2148ec18/.forgejo/workflows/actions.yml#L22-L37).

### steps

The `steps` context contains information about the `steps` in the current job that have
an id specified (`jobs.<job_id>.step[*].id`) and have already run.

The `steps.<step_id>.outputs` object is a key/value map of the output of the
corresponding step, defined by writing to `$FORGEJO_OUTPUT`. For instance:

```yaml
- id: mystep
  run: echo 'check=good' >> $FORGEJO_OUTPUT
- run: test ${{ steps.mystep.outputs.check }} = good
```

Values that contain newlines can be set as follows:

```yaml
- id: mystep
  run: |
    cat >> $FORGEJO_OUTPUT <<EOF
    thekey<<STRING
    value line 1
    value line 2
    STRING
    EOF
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-expression/.forgejo/workflows/test.yml).

### needs

The `needs` context contains information about the `jobs` in the current workflow that have
already run before the current job (i.e. that need it in the sense of [`jobs.<job_id>.needs`](#jobsjob_idneeds)).

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-needs/.forgejo/workflows/test.yml).

### inputs

The `inputs` context maps keys (strings) to values (also strings) when running an action. They are provided as `jobs.<job_id>.step[*].with`
in a step where `jobs.<job_id>.step[*].uses` specifies an action.

For example, an action defined with the following `action.yaml`:

```yaml
inputs:
  message-input:
    description: 'The message to print'

runs:
  using: 'composite'
  steps:
    - run: echo ${{ inputs.message-input }}
```

would have an input `input-one` which could be used by a `workflow.yaml` like this:

```yaml
steps:
  - uses: my-action
    with:
      message-input: 'message to print'
```

[Check out the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-local-action/.forgejo/workflows/test.yml)

## Environment variables

Forgejo defines some environment variables that are available on each step.

**RUNNER_TOOL_CACHE**

This is a directory where tools can be installed. Defaults to `/opt/hostedtoolcache`. Despite the name, this directory is not cached across builds anymore but the variable is kept for compatibility reasons.

If you want to enable the toolcache for actions that supports it, mount a volume to `/opt/hostedtoolcache`.

**RUNNER_TMP**

This is a temporary directory provided by the runner. It's hardcoded to `/tmp`.

**RUNNER_OS**

The operating system of the runner, e.g. `Linux`

**RUNNER_ARCH**

The cpu architecture of the runner
