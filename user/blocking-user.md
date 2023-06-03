---
layout: '~/layouts/Markdown.astro'
title: Blocking a user
license: 'CC-BY-SA-4.0'
---

Blocking another user is desirable if they are acting maliciously or are spamming your repository. For such cases, Forgejo provides the functionality to block other users. Please note that in this version, you can only block another user from your own account and not from an organization's account. When you block a user, Forgejo does not explicitly notify them, but they may learn through an interaction with you that is blocked.

## How to block someone

In order to block another user, go to their profile page and click on the "Block" button.

![Profile card where block button is shown](../../../../images/v1.20/user/block/profile.png)

A popup will show; please read carefully what blocking another user implies, and if you accept the implications, click on Yes.

![Popup where implications of the block action is listed](../../../../images/v1.20/user/block/popup.png)

## Implications of blocking a user

When you block a user:

- You stop following them.
- They stop following you.

After you've blocked them:

- They cannot cause any notifications for you anymore by mentioning you.
- They cannot open issues or pull requests on repository you own.
- They cannot add reactions to your comments.
- They cannot post comments on issues and pull request you've opened.
