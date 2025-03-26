---
title: Localization admin duties
license: 'CC-BY-SA-4.0'
---

Localization team members with admin rights on both Forgejo and Weblate
are expected to make sure the translations land in the Forgejo
repository and resolve conflicts when they arise.

## Merging translations in Forgejo

Weblate is [configured to propose pull requests](https://translate.codeberg.org/settings/forgejo/forgejo/#vcs)
to the Forgejo repository with new translations. These pull requests are normally
merged with a **merge commit** into the Forgejo development branch as follows:

- If the PR title has prefix **[skip ci]**, remove it
- If no translation activity is expected before the merge, update the PR to
  trigger a CI run:
  - Change some translation(s). You can modify `[translation_meta]test` in some language
  - **Commit** changes in the [repository management](https://translate.codeberg.org/projects/forgejo/forgejo/#repository)
    of the main component
- Wait for a moment when there are no uncommitted translation changes and the CI
  checks are passed. **Commit** button will be disabled in [repository management](https://translate.codeberg.org/projects/forgejo/forgejo/#repository)
  when there are no such changes.
- **Merge** the pending **i18n:** pull request with a **commit message**
  similar to this example:
  - [Pull request](https://codeberg.org/forgejo/forgejo/pulls/7240)
  - [Merge commit](https://codeberg.org/forgejo/forgejo/commit/0b73a1da00ba92aabf5782ff62264a96bcbd1638)
  - [The actual commit](https://codeberg.org/forgejo/forgejo/commit/5a7af0dae2ef1c7d18ea5ac53ae8682d9d0c28df)
- Visit [Weblate history](https://translate.codeberg.org/changes/browse/forgejo/)
  and make sure there's a message about succsessful rebase

## Merging a pull request that changes translations

When a [Forgejo pull request](https://codeberg.org/forgejo/forgejo/pulls)
modifies locale files other than base which is en-US, it must be merged after
all pending changes in Weblate are merged, while the impacted components are locked.

- lock Weblate component(s)
- merge the pending `i18n:` pull request based on the instructions above
- rebase the other PR if needed, merge it
- unlock component(s)
- make sure Weblate rebased successfully, you can use `Update` button in main component to trigget that

## Resolving failures

### Weblate locked due to network error

Sometimes a connectivity error with Codeberg or it's unavailability can cause Weblate to lock. The lock error looks like this:

```
kex_exchange_identification: Connection closed by remote host
Connection closed by 217.197.91.145 port 22
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
 (128)
```

Weblate will retry connection attempts but it takes hours before it does that. If Codeberg is currently [available](https://status.codeberg.eu/) and working, the project can simply be unlocked manually to allow the translators to keep working.

### Commit changing non-base locales was merged before Weblate

If a commit changing translation files other than `en_US.ini` was merged before all changes from Weblate were merged, it could have caused Weblate to lock itself due to failed rebase.
If the rebase did succeed, everything is ok and no steps need to be taken, just be more cautious with merges next time.
If Weblate failed to rebase, there are two ways to solve this issue.

#### Revert and merge in correct sequence

1. Make a PR that reverts the commit that caused the breakage
2. Merge this PR
3. Make Weblate commit and push all changes
4. Merge the Weblate PR
5. Rebase the commit(s) of the PR that caused the breakage on top of the merged Weblate commit, open a new PR

#### Merge translations manually

1. Fetch the branch that Weblate uses:
   `git remote add weblate https://translate.codeberg.org/git/forgejo/forgejo`
   `git fetch -u weblate`
   `git checkout weblate/forgejo`
2. Checkout into a new branch:
   `git checkout -b i18n-weblate-recovery`
3. Rebase it on top of latest commit in main Forgejo branch
   `git rebase -i <latest-commit>`
4. Propose a new PR with fixed commit and merge it
5. Close PR created by Weblate, reset Weblate

Alternatively to rebase you can also interactively cherry-pick the commit on top of a new branch based on latest.

## Other merge strategies

Forgejo used to have different merge workflows based on squashing the PR. The
old instructions are available in [older version of the documentation](/docs/v10.0/contributor/localization-admin/).
