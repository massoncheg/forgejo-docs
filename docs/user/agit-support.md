---
title: 'AGit Setup'
license: 'Apache-2.0'
origin_url: 'https://github.com/go-gitea/gitea/blob/abe8fe352711601fbcd24bf4505f7e0b81a93c5d/docs/content/usage/agit-support.en-us.md'
---

Forgejo ships with limited support for [AGit-Flow](https://git-repo.info/en/2020/03/agit-flow-and-git-repo/). It was originally introduced in Gitea `1.13`.

Similarly to [Gerrit](https://www.gerritcodereview.com), it is possible to create Pull Requests to a target repository by pushing directly to that said repository, without having to create feature branches or forks.

## Creating Pull Requests

Creating a new Pull Request can be done by pushing to the branch that you are targeting followed by a specific [refspec](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec) (a location identifier known to Git).

For clarity, suppose that you cloned a repository and created a new commit on top of the `main` branch. Here is you can create a Pull Request targeting the `main` branch:

```shell
git push origin HEAD:refs/for/main -o topic="hello-world"
```

It is possible to use some additional parameters, such as `topic`, `title` and `description`. Here's another example targeting the `master` branch:

```shell
git push origin HEAD:refs/for/master -o topic="Topic of my PR" -o title="Title of the PR" -o description="# The PR Description\nThis can be **any** markdown content.\n- [x] Ok"
```

### Parameters

The following parameters are available:

- `HEAD`: The target branch **(required)**
- `refs/<for|draft|for-review>/<branch>`: The target PR type **(required)**
  - `for`: Create a normal PR with `<branch>` as the target branch
  - `draft`/ `for-review`: Currently ignored silently
- `<branch>/<session>`: The target branch to open the PR **(required)**
- `-o <topic|title|description>`: Options for the PR
  - `title`: The PR title. If left empty, the first line of the first new Git commit will be used instead.
  - `topic`: The branch name the PR should be opened for. **(required)**
  - `description`: The PR description
  - `force-push`: confirm force update the target branch

### Caveats

Pushing new changes to an existing Pull Request created with Agit requires some caution. Otherwise, Forgejo may not be able to associate your new changes with your existing Pull Request, resulting in the creation of a new Pull Request.

If you wish to push additional changes to a pull request that you previously created using Agit, you **must** use the same topic that you used before.

If you rebase your local commits, you **must** use the topic you previously used **together** with the `force-push` option.
