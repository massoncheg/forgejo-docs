---
title: 'Forgejo Actions | GitHub Actions'
license: 'CC-BY-SA-4.0'
---

If you are familiar with GitHub Actions, you'll likely recognize many things in Forgejo Actions. Forgejo Actions is designed to be familiar to users of GitHub Actions, but it is **not designed to be compatible**.

## Familiarity instead of compatibility

Forgejo Actions is built on top of several existing technologies that were built to emulate GitHub Actions. For this reason, Forgejo Actions will seem very similar to GitHub Actions. Many features are (nearly) identical: workflows defined by YAML files in the repository, a swarm of runners executing actions inside docker containers, the ability to reuse workflows with Actions.

However, GitHub has different constraints when designing GitHub Actions. Because of this, they are able to add some features that are not a great fit for Forgejo Actions. On the other hand, Forgejo Actions has some features that GitHub Actions doesn't have, like running workflows in LXC containers.

Overall, many features from GitHub Actions translate one-to-one to Forgejo Actions. It is mostly the small differences that mean we can't claim to be 100% compatible. These small things are also usually the most difficult and least useful for our users to implement. And, since GitHub continues development on GitHub Actions, keeping up with all the changes would be impractical.

For all of these reasons, Forgejo Actions strives for _familiarity_ instead of _compatibility_. We want users of GitHub actions to feel familiar using Forgejo Actions, even if there are some small changes here and there. Workflows should work with some minimal changes.

If there is a feature you are missing, you are welcome to [discuss it](https://code.forgejo.org/forgejo/runner/issues), but keep in mind this philosophy.

## Known list of differences

> This list may be incomplete. If you find a notable difference, you can [edit this page](https://codeberg.org/forgejo/docs/src/branch/next/docs/user/actions/github-actions.md).

- The default environment is very different. Most Forgejo Runners use a Debian bookworm image with just node.js by default, while GitHub uses a larger `ubuntu` image.
- Some keys in the `github` context are missing.
- Certain subkeys on the `job` key in workflow files are ignored, like `permissions`, and `continue-on-error`.
- Enabling [OIDC ID token generation](./security-openid-connect) uses the [`enable-openid-connect`](./reference#enable-openid-connect) key in the workflow file instead of `permissions: id-token: write`
