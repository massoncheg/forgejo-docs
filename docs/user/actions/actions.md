---
title: Forgejo Actions | Using Actions
license: 'CC-BY-SA-4.0'
---

Actions are reusable pieces of code that you can use in your CI workflows.

## Using Actions

For example, to check out the contents of the repository you can use the [`actions/checkout`](https://code.forgejo.org/actions/checkout) action. To use it, add the following step to a job in your workflow:

```yaml
- name: Check out the repository
  uses: https://data.forgejo.org/actions/checkout@v4
```

This specifies that this step `uses` the action `https://data.forgejo.org/actions/checkout`, version `v4`.

You can also specify an action like `uses: actions/checkout@v4`. In this case the runner will prefix it with the `DEFAULT_ACTIONS_URL` and proceed like normal. The `DEFAULT_ACTIONS_URL` is `https://data.forgejo.org/` by default, but it can be changed by the instance administrator. For this reason **it is strongly recommended to use fully qualified URLs**. In this guide we will use the shorter notation for brevity.

You can also load an action from a local directory instead of a remote repository. This is called a [local action](#local-actions).

### Action inputs

An Action can have parameters, called `input`s. You can usually read which inputs an action has in its README. To specify the inputs for an action, you can use the `with` key like so:

```yaml
- name: Check out the repository
  uses: actions/checkout@v4
  with:
    ref: my-feature-branch
    path: some/subdirectory
    show-progress: true
```

### Action dependencies

Since Actions are simply scripts run in your CI workflow, they usually have dependencies. For example, the `actions/checkout` action depends on NodeJS. If it is not present the action will fail. When using non-standard container images it is important to check that the required dependencies are present. If they are not you can try these fixes:

- Find a container image that does have the dependencies pre-installed.
- Install the dependencies _during_ the workflow, by using a package manager.
- Find an alternative action that doesn't have the dependencies.

### Local actions

If an action's `uses` statement starts with `./` it will be loaded from the specified local directory, instead of being cloned from a remote repository. The layout and content of the actions directory will be exactly the same as with a remote action.

[Take a look at the example](https://code.forgejo.org/forgejo/end-to-end/src/branch/main/actions/example-local-action/).

The action is taken from a local directory, from the perspective of the runner. This means you will typically need to have a checkout action before being able to use a local action.

## Creating your own actions

It is fairly simple to create your own actions. An action is really just a directory with an `action.yml` in it. There are three types of actions, `node`, `docker` and `composite`.

These types of actions are both explained further below.

> **Tip:** When first developing an action, it is useful to load it as a [local action](#local-actions) for testing.

### `action.yml`

The `action.yml` file contains all the metadata for the action. It decides the name, description, inputs, outputs and how to run the action.

Take a look at this simple example:

```yaml
name: 'Example Action'
author: 'Me, I wrote it'
description: |
  A simple action that just takes some input and writes it to a file.

inputs:
  message:
    description: 'The message to be stored'
    default: 'default message'

outputs:
  time:
    description: 'The time when the action was run'

runs: ...
```

The content of the `runs` key determines what type of action it is.

### `node` actions

Node actions are executed using NodeJS. NodeJS will _not_ automatically be installed, so if it is not present in the container image the action will fail.

Node actions have the following information in the `runs` key:

```yaml
runs:
  using: 'node20'
  main: 'index.js'
```

The `main` key determines the entry point for execution.

For more information about writing node actions, check [the GitHub documentation](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-javascript-action). Keep in mind that certain details differ between GitHub and Forgejo.

### `docker` actions

Docker actions are executed using a container engine. They can only be used on runners that provide one, like Docker or Podman.

Docker actions have the following information in the `runs` key:

```yaml
runs:
  using: 'docker'
  image: 'Containerfile'
  args:
    - ${{ inputs.message }} # This also needs to be defined in the inputs section above.
```

The `image` key points at the `Containerfile` that should be used to build the image that will be run. The Containerfile contains the configuration for the base image, as well as an entrypoint. Arguments can be passed with the `args` key.

For more information about writing Docker actions, check [the GitHub documentation](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-docker-container-action). Keep in mind that certain details differ between GitHub and Forgejo.

### `composite` actions

Composite actions are simply a series of steps from a normal workflow, packaged as an action for easier reuse.

Composite actions have the following information in the `runs` key:

```yaml
runs:
  using: 'composite'
  steps:
    - name: Print message
      run: echo "$MESSAGE"
      shell: bash
      env:
        MESSAGE: ${{ inputs.message }} # This also needs to be defined in the inputs section above.

    - name: Some other step
      ...
```

Composite actions can use other actions just like normal workflows. You can also write scripts, commit them to the action repository, and then use them in the action by calling them with a `run` key.
