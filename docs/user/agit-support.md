---
title: 'AGit Workflow Usage'
license: 'Apache-2.0'
origin_url: 'https://github.com/go-gitea/gitea/blob/e865de1e9d65dc09797d165a51c8e705d2a86030/docs/content/usage/agit-support.en-us.md'
---

Forgejo ships with limited support for [AGit-Flow](https://git-repo.info/en/2020/03/agit-flow-and-git-repo/). It was originally introduced in Gitea `1.13`.

Similarly to [Gerrit's workflow](https://www.gerritcodereview.com), this workflow provides a way of submitting changes to repositories hosted on Forgejo instances using the `git push` command alone, without having to create forks or feature branches and then using the web UI to create a Pull Request.

Using Push Options (`-o`) and a [Refspec](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec) (a location identifier known to Git), it is possible to supply the information required to open a Pull Request, such as the target branch or the Pull Request's title.

## Creating Pull Requests

For clarity, this document will start with some examples.

A full list of the parameters, as well as information on avoiding duplicate Pull Requests when rebasing or amending commits, will follow.

### Usage Examples

Suppose that you cloned a repository and created a new commit on top of the `main` branch. A Pull Request targeting the `main` branch using your **currently checked out branch** can be created like this:

```shell
git push origin HEAD:refs/for/main -o topic="agit-typo-fixes"
```

Note that `HEAD:refs/for/main` is the [Refspec](https://git-scm.com/book/en/v2/Git-Internals-The-Refspec). `HEAD` refers to the [checked out reference](https://git-scm.com/book/en/v2/Git-Internals-Git-References), but can be replaced with any ["local ref"](https://git-scm.com/docs/git-push). `refs/for/main` refers to the destination (**"remote ref"**), with `main` being the **"target branch"**, as in the branch that your submitted change should be applied to.

The topic will be visible in the Pull Request and it will be used to associate further commits with the same Pull Request.

#### Setting a topic using the session parameter.

Topics can also be defined using the `<session>` parameter in the **Refspec**. In the following example, we create a new pull request using the currently checked out reference (`HEAD`). The target branch will be `main`. The topic will be `topic-branch`.

```shell
# topic-branch is the session parameter and the topic
git push origin HEAD:refs/for/main/topic-branch
```

#### Pushing a non-checked-out reference (non-HEAD)

Suppose you would like to submit a Pull Request meant for a remote branch called `remote-branch` using topic `topic`.
However, the changes that you want to submit reside in a local branch called `local-branch` that you have not checked out. In order to submit the changes residing in the `local-branch` branch **without** checking it out, you can supply the name of the local branch (`local-branch`) as follows:

```shell
git push origin local-branch:refs/for/remote-branch/topic
```

#### Setting a title and a description in AGit

It is also possible to use some additional parameters, such as `title` and `description`. Here's another example targeting the `main` branch:

```shell
git push origin HEAD:refs/for/main -o topic="topic-branch" \
  -o title="Title of the PR" \
  -o description="# The PR Description
This can be **any** markdown content.\n
- [x] Ok"
```

#### Changing the default push method

To push commits to your Pull Request without having to specify the Refspec, you can modify the [default push method](https://git-scm.com/docs/git-config#Documentation/git-config.txt-pushdefault) to `upstream` in your Git configuration:

```shell
# To only set this option for this specific repository
git config push.default upstream
# Or run this instead if you want to set this option globally
git config --global push.default upstream
```

Then, run the following command:

```shell
git config branch.local-branch.merge refs/for/main/topic-branch
```

After doing so, you can now simply run `git push` to push commits to your pull request, without having to specify the refspec.
This will also allow you to pull, fetch, rebase, etc., from the AGit pull request by default.

Alternatively,

### Parameters

```sh
git push <remote-name> <local-ref>:refs/for[draft|for-review]/<branch>/<session> [-o <topic|title|description|force-push>]
```

The following parameters are available:

- `<remote-name>`: The name of the remote repository (e.g., `origin`) **(required)**
- `<local-ref>`: The local reference being pushed (e.g., `HEAD`, `my-branch`, a commit hash) **(required)**
- `refs/<for|draft|for-review>/<branch>/<session>`: Refspec **(required)**
  - `for`/`draft`/`for-review`: This parameter describes the Pull Request type. **for** opens a normal Pull Request. **draft** and **for-review** are currently silently ignored.
  - `<branch>`: The target branch that a Pull Request should be merged against **(required)**
  - `<session>`: The session identifier or topic for the remote pull request. **If left empty,** the topic must be supplied using the `-o topic` option.
- `-o <topic|title|description|force-push>`: Push options
  - `topic`: Essentially an identifier. **If left empty,** the value of `<session>`, if present, will be used for the topic. Otherwise, Forgejo will return an error. If you want to push additional commits to a Pull Request that was created using AGit, you **must** use the same topic.
  - `title`: Title of the Pull Request. **If left empty,** the first line of the first new Git commit will be used instead.
  - `description`: Description of the Pull Request.
  - `force-push`: Necessary when rebasing, amending, or [retroactively modifying](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History) your previous commits. Otherwise, a new Pull Request will be opened, **even if you use the same topic**. If used, the value of this parameter should be set to `true`.

Forgejo relies on the `topic` parameter and a linear commit history in order to associate new commits with an existing Pull Request. Should you wish to overwrite the contents of an existing pull request, use the `force-push` parameter.

**For Gerrit users:** Forgejo does not support [Gerrit's Change-Ids](https://gerrit-review.googlesource.com/Documentation/user-changeid.html).
