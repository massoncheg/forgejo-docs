---
title: 'Merge Message Templates'
license: 'Apache-2.0'
origin_url: 'https://github.com/go-gitea/gitea/blob/e865de1e9d65dc09797d165a51c8e705d2a86030/docs/content/usage/merge-message-templates.en-us.md'
---

## File Names

Possible file names for PR (Pull Request) default merge message templates:

- `.forgejo/default_merge_message/MERGE_TEMPLATE.md`
- `.forgejo/default_merge_message/REBASE_TEMPLATE.md`
- `.forgejo/default_merge_message/REBASE-MERGE_TEMPLATE.md`
- `.forgejo/default_merge_message/SQUASH_TEMPLATE.md`
- `.forgejo/default_merge_message/MANUALLY-MERGED_TEMPLATE.md`
- `.forgejo/default_merge_message/REBASE-UPDATE-ONLY_TEMPLATE.md`

Note: `.gitea` as the root directory is also recognized and kept only for compatibility reasons.

If Forgejo cannot find the file in the repository, it will search the _`CustomPath`_ for a folder named `default_merge_message` which may contain site-wide templates.

## Title/Body separation

The first line of the template creates the title, the rest makes the body of the message. Without a template, the default texts are:

- **Title** : `Merge pull request '[PR title]' ([PR reference]) from [head branch] into [base branch]`.
- **Body** : `Reviewed-on: [PR url]`.

You can customize the title and body of the default message following these rules:

- To replace each of those sections the first line of the template is used to replace the title and other lines the body.
- For the title, leading and trailing whitespace is trimmed
- For the body, trailing whitespace is trimmed from each line
- If only the title is meant to be changed a single-line template can be used.
- To keep the default title but change the default body the template needs to start with a newline `\n` character.
- To remove the default title (make it empty) any white-space character can be inserted in the first line of the template, as trailing white spaces are trimmed.

### Examples

Replace the default title and keep the default body:

```
Merge Title
```

Replace the default title and make the default body empty:

```
Merge Title\n

```

Keep the default title and replace the default body:

```
\n
Merge Body
```

The space in the first line makes the default title empty and replace the default body:

```
 \n
Merge body
```

## Variables

You can use the following variables enclosed in `${}` inside these templates, which follow [os.Expand](https://pkg.go.dev/os#Expand) syntax:

- BaseRepoOwnerName: Base repository owner name of this pull request
- BaseRepoName: Base repository name of this pull request
- BaseBranch: Base repository target branch name of this pull request
- HeadRepoOwnerName: Head repository owner name of this pull request
- HeadRepoName: Head repository name of this pull request
- HeadBranch: Head repository branch name of this pull request
- PullRequestTitle: Pull request's title
- PullRequestDescription: Pull request's description
- PullRequestPosterName: Pull request's poster name
- PullRequestIndex: Pull request's index number
- PullRequestReference: Pull request's reference character with index number, i.e., #1, !2
- ClosingIssues: A string containing all issues that will be closed by this pull request, i.e., `close #1, close #2`
- ReviewedOn: A string containing `Reviewed-on: <link>` with the link to the pull request
- ReviewedBy: Lines containing `Reviewed-by: <username> <<email>>` with the names and emails of the reviewers

## Rebase

When rebasing without a merge commit, `REBASE_TEMPLATE.md` modifies the message of the last commit. The following additional variables are available in this template:

- CommitTitle: Commit's title
- CommitBody: Commit's body text
