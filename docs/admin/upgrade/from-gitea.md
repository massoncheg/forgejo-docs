---
title: 'Gitea migration'
license: 'CC-BY-SA-4.0'
---

This guide describes how to go from Gitea to Forgejo.

Upgrades are supported [up to Gitea v1.22 included](https://forgejo.org/2024-12-gitea-compatibility/), in two steps:

- Upgrade from any Gitea version up to and including v1.22.x to Forgejo v10.0.x.
- Upgrade from Forgejo v10.0.x to any Forgejo version greater than v10.

Here's what to expect, and some helpful tips:

- First of all, ensure you have good backups. Ideally, shut down Gitea and do a backup of your database and files (Git repositories, attachments etc), or ideally of the whole server. This will make it a lot more relaxed to fiddle with the setup.
- Forgejo will run automatic migrations in the database to convert some structures.
- There should be no automatic modification of the app.ini related to this upgrade, but it is generally recommended to let Forgejo write to the config file because it is used to store some secrets.

## Native (Package Manager) installation

If Gitea is installed via a package manager:

### Arch Linux

Arch Linux provides package for both Gitea and Forgejo,
but they install to different locations and run as different users.
Therefore, a small amount of work is needed to transition from one to the other.

First step is to install the Forgejo package, and stop the Gitea service.

    $ pacman -S forgejo
    $ systemctl stop gitea

#### Configuration migration

Now, we can copy the Gitea configuration over the default Forgejo one.
We need to set the group owner and group write permission so Forgejo can write to it.

    $ cp /etc/gitea/app.ini /etc/forgejo/app.ini
    $ chown root:forgejo /etc/forgejo/app.ini
    $ chmod g+w /etc/forgejo/app.ini

#### Data migration

If we want to leave a copy of the Gitea data untouched (recommend in case of mistakes)
the next step is to copy the existing data to the Forgejo user's home directory.
We need to change the ownership of the files to the `forgejo` user and group too:

    $ cp -r /var/lib/gitea/* /var/lib/forgejo
    $ chown -R forgejo: /var/lib/forgejo/*

Finally, we need to update the configuration, which currently points to `/var/lib/gitea`,
to point to the new location.
Edit `/etc/forgejo/app.ini` and replace all instances of `/var/lib/gitea` with `/var/lib/forgejo`.

#### Data migration (no copy)

If you're not concerned about being able to roll back to your Gitea installation,
you can simply change the owner of the files in `/var/lib/gitea`.
There's then no need to change the configuration.

    $ chown -R forgejo: /var/lib/gitea/*

#### Starting Forgejo

Whichever data migration you've chosen, it's now time to start the Forgejo service.

    $ systemctl start forgejo

Check to see that the service has started with no issues.

    $ systemctl status forgejo

...and set the service to start automatically.

    $ sytemctl enable forgejo

Finally, if you're happy with everything, you can uninstall Gitea.

    $ pacman -R gitea

## Containerized (docker, podman, etc) installation

If gitea was running as a container, it makes sense to run forgejo the same way.
If all goes well, forgejo 10.x should act as a drop-in replacement for gitea 1.22.x.
Pay special attention to paths and environment variables.

If you were running a rootless gitea container, a rootless forgejo container should
work similarly. The data should be owned by user 1000 and group 1000.

### Configuring paths

The main configuration file is `app.ini`. This file controls the locations of all
other data. If your app.ini specifies the locations of things, those things should
continue to work. For unspecified things, pay close attention to the
[configuration cheat-sheet](https://forgejo.org/docs/latest/admin/config-cheat-sheet/#default-configuration-non-appini-configuration)
as the defaults may have changed.

### Environment variables

The location of `app.ini` is currently specified by the `GITEA_APP_INI`
environment variable. If unset, the default is `/var/lib/gitea/custom/conf/app.ini`.
If the file is not present, `/etc/gitea/app.ini` is used as a fallback.

These variables are named with a "GITEA*" prefix for compatibility reasons.
They may change in the future. It is recommended to pass two copies of
these variables to your container: one with the prefix "GITEA*", and again
with the prefix "FORGEJO\_", to remain compatible with future versions of
Forgejo.

## Troubleshooting

Here are some common problems and how to solve them. Contributions are welcome.

### Missing favicon or logo

Files from `public/assets/img/` must live in `custom/` now; otherwise, they will have no effect.

See [here](https://forgejo.org/docs/next/contributor/customization/#changing-the-logo)
for details of where these things should live.
Also see [here](https://forgejo.org/docs/next/admin/advanced/customization/#a-word-of-warning-here-be-dragons)
for the necessary warnings and disclaimers.

The browser caches images, so after changing it, it may take some refreshes or cache-clears to see the change.

### 404 error when downloading a package

Check (and double-check) your configured paths. Refer to the [storage documentation](https://forgejo.org/docs/latest/admin/storage/), and double-check what the configured path is relative to.

### Action fails to run with "repository not found"

If the "Set up job" section fails with "repository not found", it's probably trying to pull the action from the wrong place.

Workflow tasks defined with `uses:` and a relative URL are pulled from
a mirror. Gitea and Forgejo have their own mirrors. Gitea mirrors some
things that Forgejo does not, and vice versa.

To solve this, you can change the default mirror, as described
[here](https://forgejo.org/docs/latest/admin/actions/#default-actions-url),
or you can change the `uses:` field to specify a full URL.

For example, if you trust that the upstream github project will remain compatible and sane:

    uses: sammcj/dotenv-output-action@main

might become:

    uses: https://github.com/sammcj/dotenv-output-action@main
