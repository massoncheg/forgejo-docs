---
title: 'Moderation tools'
license: 'CC-BY-SA-4.0'
---

Moderation tools are meant to help the Forgejo users and admins handle
spam bots and undesirable interactions.

## Email notifications to instance admins on new user sign-up

`[admin].SEND_NOTIFICATION_EMAIL_ON_NEW_USER` can be set to `true` on
small Forgejo instances with an open registration. Such instances are
subject to occasional spam bots registrations and saves the admin the
trouble to check on a regular basis. Read more in the [config cheat
sheet](../../config-cheat-sheet/#admin-admin).

## Self moderation tools

On large instances the moderation team may be too busy with fighting
spam to handle problematic relationships between users. Self
moderation tools may help in this case and allow users to block any
unwanted interaction from another user. Read more in the [user
blocking guide](../../../user/blocking-user/).

## Deleting users together with their content

To delete a user, including all the repositories or issues they
created the Forgejo admin can either:

- Use the administration panel of the web interface
- Use the `forgejo admin user delete --purge` command line. Read more in the [command line documentation](../../command-line/#admin-user-delete).

## Abusive content reporting

By default this functionality is disabled and can be enabled by adding the following lines within `app.ini` config file:

```ini
[moderation]
ENABLED = true
```

Optionally, you can also define the amount of time after which the resolved reports will be automatically deleted if the [corresponding cron](../../config-cheat-sheet/#cron---remove-resolved-reports-cronremove_resolved_reports) is enabled:

```ini
KEEP_RESOLVED_REPORTS_FOR = 168h
```

When enabled, within the '⋯' context menu from user profile pages and organization pages a new 'Report abuse' action will be available while for repositories, issues, pull requests and comments the '⋯' menu will get a 'Report content' action.

_Note that the new actions will not be available for your profile, for issues, pull requests and comments posted by you, or for organizations and repositories owned by you._

Clicking on 'Report abuse' or 'Report content' will open a new page where the user is able to select from a predefined list of categories and add some remarks before submitting the report to administrators.

At the same time, a new 'Moderation reports' section will be available within the 'Site administration' page, where administrators can see an overview with the submitted abuse reports that are still open (not yet handled in any way). When multiple reports (submitted by distinct users) exist for the same content only the first one will be shown in the list and a counter can be seen on the right side (indicating the number of open reports for the same content type and ID). Clicking on the counter or the adjacent icon will open the details page where a list with all the reports (one or multiple) linked to the reported content is shown, as well as any shadow copy saved for the current report(s).

Below the right side counters from the overview page there are also some buttons that can be used to:

- mark a report as Handled or as Ignored (without performing any action on the reported content);
- mark a user account as suspended (prohibited from signing in and existing sessions won't work any more, but please note that SSH access could still be allowed);
- delete (and purge) a user / organization and mark the linked reports as Handled;
- delete a repository and mark the linked reports as Handled;
- delete an issue / pull request and mark the linked reports as Handled;
- delete a comment and mark the linked reports as Handled;

_Only the buttons for updating the status of the report are directly visible - as '✓' and '✗' icons with some tooltips - while the content actions are hidden under a '⋯' dropdown._
