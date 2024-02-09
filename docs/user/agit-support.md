---
title: 'Agit Setup'
license: 'Apache-2.0'
origin_url: 'https://github.com/go-gitea/gitea/blob/abe8fe352711601fbcd24bf4505f7e0b81a93c5d/docs/content/usage/agit-support.en-us.md'
---

Forgejo ships with limited support for [Agit](https://git-repo.info/en/2020/03/agit-flow-and-git-repo/).

Agit allows creating pull requests to a target repository by pushing directly to the target, without having to create forks or accessing the web UI.

## Creating Pull Requests

Creating a new Pull Request can be done by pushing to the branch of your choice followed by a specific refspec (a location identifier known to Git).

Here is an example:

```shell
git push origin HEAD:refs/for/master
```

The command has the following structure:

- `HEAD`: The target branch **(required)**
- `refs/<for|draft|for-review>/<branch>`: The target PR type **(required)**
  - `for`: Create a normal PR with `<branch>` as the target branch
  - `draft`/ `for-review`: Currently ignored silently
- `<branch>/<session>`: The target branch to open the PR **(required)**
- `-o <topic|title|description>`: Options for the PR
  - `title`: The PR title
  - `topic`: The branch name the PR should be opened for **(required)**
  - `description`: The PR description
  - `force-push`: confirm force update the target branch

### Caveats

Pushing new changes to an existing Pull Request created with Agit requires some caution. Otherwise, Forgejo may not be able to associate your new changes with your existing Pull Request, resulting in the creation of a new Pull Request.

If you wish to push additional changes to a pull request that you previously created using Agit, you **must** use the same topic that you used before.

If you rebase your local commits, you **must** use the topic you previously used **together** with the `force-push` option.

### Examples

In this example, we will create a new PR targeting `master` using the parameters `topic`, `title`, and `description`:

```shell
git push origin HEAD:refs/for/master -o topic="Topic of my PR" -o title="Title of the PR" -o description="# The PR Description\nThis can be **any** markdown content.\n- [x] Ok"
```
