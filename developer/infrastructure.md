---
layout: '~/layouts/Markdown.astro'
title: Hardware infrastructure
license: 'CC-BY-SA-4.0'
---

## Codeberg

Codeberg provides a LXC container with 48GB RAM, 24 threads and SSD drive to be used for the CI. A Forgejo Runner is installed in `/opt/runner` and registered with a token obtained from https://codeberg.org/forgejo. It does not allow running privileged containers or LXC containers for security reasons. The runner is intended to be used for pull requests, for instance in https://codeberg.org/forgejo/forgejo.

## Octopuce

[Octopuce provides hardware](https://codeberg.org/forgejo/sustainability) managed by [the devops team](https://codeberg.org/forgejo/governance/src/branch/main/TEAMS.md#devops). It can be accessed via a VPN which provides a DNS for the `octopuce.forgejo.org` internal domain.

The VPN is deployed and upgraded using the following [Enough command line](https://enough-community.readthedocs.io):

```shell
$ mkdir -p ~/.enough
$ git clone https://forgejo.octopuce.forgejo.org/forgejo/enough ~/.enough/octopuce.forgejo.org
$ enough --domain octopuce.forgejo.org service create openvpn
```

## OVH

https://code.forgejo.org runs on an OVH virtual machine using the same
OVH account used for the forgejo.org domain name and mails.

It is deployed and upgraded using the following [Enough command line](https://enough-community.readthedocs.io):

```shell
$ mkdir -p ~/.enough
$ git clone https://code.forgejo.org/forgejo/<secret repository> ~/.enough/code.forgejo.org
$ enough --domain code.forgejo.org service create --host bind-host forgejo
```

Upgrading only Forgejo:

```shell
$ enough --domain code.forgejo.org playbook -- --limit bind-host,localhost --private-key ~/.enough/code.forgejo.org/infrastructure_key venv/share/enough/playbooks/forgejo/forgejo-playbook.yml
```

Login in the machine hosting the Forgejo instance for debugging purposes:

```shell
enough --domain code.forgejo.org ssh bind-host
```
