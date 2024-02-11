---
title: 'AGit Setup'
license: 'Apache-2.0'
origin_url: 'https://github.com/go-gitea/gitea/blob/abe8fe352711601fbcd24bf4505f7e0b81a93c5d/docs/content/usage/agit-support.en-us.md'
---

Forgejo ships with limited support for [AGit-Flow](https://git-repo.info/en/2020/03/agit-flow-and-git-repo/). It was originally introduced in Gitea `1.13`.

Similarly to [Gerrit's workflow](https://www.gerritcodereview.com), this workflow provides a way of submitting changes to a remote repository using the `git push` command alone, without having to create forks or feature branches and then using the web UI to create a Pull Request.

Using Push Options (`-o`) and a [Refspec](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec) (a location identifier known to Git), it is possible to supply the information required to open a Pull Request, such as the target branch or the Pull Request's title.

## Creating Pull Requests

For clarity reasons, this document will lead with some examples first.

A full list of the parameters, as well as information on avoiding duplicate Pull Requests when rebasing or amending a commit, will follow.

### Usage Examples

Suppose that you cloned a repository and created a new commit on top of the `main` branch. A Pull Request targeting the `main` branch can be created like this:

```shell
git push origin HEAD:refs/for/main -o topic="topic-branch"
```

The topic branch can also be supplied directly in the refspec:

```shell
git push origin HEAD:refs/for/main/topic-branch
```

It is also possible to use some additional parameters, such as `topic`, `title` and `description`. Here's another example targeting the `master` branch:

```shell
git push origin HEAD:refs/for/master -o topic="topic-branch" \
  -o title="Title of the PR" \
  -o description="# The PR Description
This can be **any** markdown content.\n
- [x] Ok"
```

#### A More Complex Example

Suppose that the currently checked out branch in your local repository is `main`, yet you would like to submit a Pull Request meant for a remote branch called `remote-branch`.

However, the changes that you want to submit reside in a local branch called `local-branch`. In order to submit the changes residing in the `local-branch` branch **without** checking it out, you can supply the name of the local branch (`local-branch`) using the `<session>` parameter:

```shell
git push origin HEAD:refs/for/remote-branch/local-branch \
  -o topic="my-first-contribution" \
  -o title="My First Pull Request!"
```

This syntax may be a bit disorienting for users that are accustomed to commands such as `git push origin remote-branch` or `git push origin local-branch:remote-branch`.

Just like when using `git push origin remote-branch`, it is important to reiterate that supplying the local branch name is optional, as long as you checkout `local-branch` using `git checkout local-branch` beforehand.

### Parameters

The following parameters are available:

- `HEAD`: The target branch **(required)**
- `refs/<for|draft|for-review>/<branch>/<session>`: Refspec **(required)**
  - `for`/`draft``for-review`: This parameter describes the Pull Request type. **for** opens a normal Pull Request. **draft** and **for-review** are currently silently ignored.
  - `<branch>`: The target branch that a Pull Request should be merged against **(required)**
  - `<session>`: The local branch that should be submitted remotely. If left empty, the currently checked out branch will be used by default.
- `-o <topic|title|description|force-push>`: Push options
  - `topic`: Topic. Under the hood, this is just a branch. If you want to push any further commits to a Pull Request that was created using AGit, you **must** use the same topic, as it is used to associate your new commits with your existing Pull Request.
  - `title`: Title of the Pull Request. If left empty, the first line of the first new Git commit will be used instead.
  - `description`: Description of the Pull Request.
  - `force-push`: Necessary when rebasing or amending your previous commits. Otherwise, a new Pull Request will be opened, **even if you use the same topic**.

In summary, Forgejo relies on the `topic` parameter and a linear commit history in order to associate new commits with an existing Pull Request. If you amend a commit, squash all of your commits or otherwise [retroactively modify](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History) commits that have already been submitted, you should use the `force-push` parameter to avoid opening a duplicate Pull Request.

**For Gerrit users:** Forgejo does not support [Change-Ids](https://gerrit-review.googlesource.com/Documentation/user-changeid.html).
