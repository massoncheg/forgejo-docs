---
title: 'Gitea migration'
license: 'CC-BY-SA-4.0'
---

This guide describes how to go from Gitea to Forgejo if Gitea is installed via a package manager.

## Arch Linux

Arch Linux provides package for both Gitea and Forgejo,
but they install to different locations and run as different users.
Therefore, a small amount of work is needed to transition from one to the other.

First step is to install the Forgejo package, and stop the Gitea service.

    $ pacman -S forgejo
    $ systemctl stop gitea

### Configuration migration

Now, we can copy the Gitea configuration over the default Forgejo one.
We need to set the group owner and group write permission so Forgejo can write to it.

    $ cp /etc/gitea/app.ini /etc/forgejo/app.ini
    $ chown root:forgejo /etc/forgejo/app.ini
    $ chmod g+w /etc/forgejo/app.ini

### Data migration

If we want to leave a copy of the Gitea data untouched (recommend in case of mistakes)
the next step is to copy the existing data to the Forgejo user's home directory.
We need to change the ownership of the files to the `forgejo` user and group too.

    $ cp -r /var/lib/gitea/* /var/lib/forgejo
    $ chown -R forgejo: /var/lib/forgejo/*

Finally, we need to update the configuration, which currently points to `/var/lib/gitea`,
to point to the new location.
Edit `/etc/forgejo/app.ini` and replace all instances of `/var/lib/gitea` with `/var/lib/forgejo`.

### Data migration (no copy)

If you're not concerned about being able to roll back to your Gitea installation,
you can simply change the owner of the files in `/var/lib/gitea`.
There's then no need to change the configuration.

    $ chown -R forgejo: /var/lib/gitea/*

### Starting Forgejo

Whichever data migration you've chosen, it's now time to start the Forgejo service.

    $ systemctl start forgejo

Check to see that the service has started with no issues.

    $ systemctl status forgejo

...and set the service to start automatically.

    $ sytemctl enable forgejo

Finally, if you're happy with everything, you can uninstall Gitea.

    $ pacman -R gitea
