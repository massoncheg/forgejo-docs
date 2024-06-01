---
title: 'Installation'
license: 'CC-BY-SA-4.0'
---

Forgejo publishes a stable release every three months and a long term support
(LTS) release every year. Patch releases are published more frequently and
provide fixes for bugs and security vulnerabilities. Please review the
[releases management](../../developer/release) and
also the
[Forgejo versioning scheme](../../user/versions) documentation for further
information.

This guide covers the installation of Forgejo [with
Docker](../installation-docker/) or [from
binary](../installation-binary/). Both of these methods are created
and extensively tested to work on every release. They consist of three
steps:

- Download and run the release,
- connect to the web interface and complete the configuration, and,
- finally register the first user which will be granted administrative permissions.

If you already have Gitea installed through your package manager, look at the [Gitea
migration](../gitea-migration/) guide for information on how to install Forgejo, while
preserving your data from your Gitea installation.

Forgejo is also available for installation using package managers on many platforms. At this
time, Forgejo has been successfully adapted for use on various platforms, including Alpine Linux, Arch
Linux, Debian, Fedora, Gentoo, Manjaro, and the Nix ecosystem. These
platform-specific packages are under the care of distribution packagers, and specific packages are
currently undergoing testing. For a curated inventory, please refer to
[the "Delightful Forgejo" list](https://codeberg.org/forgejo-contrib/delightful-forgejo#packaging).
